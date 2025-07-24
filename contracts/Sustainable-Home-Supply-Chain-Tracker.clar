(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_NOT_FOUND (err u101))
(define-constant ERR_ALREADY_EXISTS (err u102))
(define-constant ERR_INVALID_STAGE (err u103))
(define-constant ERR_INVALID_RATING (err u104))

(define-data-var next-product-id uint u1)
(define-data-var next-vendor-id uint u1)

(define-map products
  { product-id: uint }
  {
    name: (string-ascii 64),
    category: (string-ascii 32),
    vendor-id: uint,
    carbon-footprint: uint,
    carbon-offset-credits: uint,
    sustainability-score: uint,
    current-stage: (string-ascii 16),
    owner: principal,
    created-at: uint
  }
)

(define-map product-lifecycle
  { product-id: uint, stage: (string-ascii 16) }
  {
    timestamp: uint,
    location: (string-ascii 64),
    handler: principal,
    verified: bool
  }
)

(define-map verified-vendors
  { vendor-id: uint }
  {
    name: (string-ascii 64),
    certification-level: uint,
    specialty: (string-ascii 32),
    verified-by: principal,
    active: bool
  }
)

(define-map green-ratings
  { product-id: uint, voter: principal }
  { rating: uint, timestamp: uint }
)

(define-map product-rating-totals
  { product-id: uint }
  { total-score: uint, vote-count: uint }
)

(define-map user-carbon-offsets
  { user: principal }
  { total-credits: uint }
)

(define-public (register-vendor (name (string-ascii 64)) (specialty (string-ascii 32)))
  (let ((vendor-id (var-get next-vendor-id)))
    (map-set verified-vendors
      { vendor-id: vendor-id }
      {
        name: name,
        certification-level: u1,
        specialty: specialty,
        verified-by: tx-sender,
        active: true
      }
    )
    (var-set next-vendor-id (+ vendor-id u1))
    (ok vendor-id)
  )
)

(define-public (register-product
  (name (string-ascii 64))
  (category (string-ascii 32))
  (vendor-id uint)
  (carbon-footprint uint)
  (carbon-offset-credits uint))
  (let ((product-id (var-get next-product-id)))
    (asserts! (is-some (map-get? verified-vendors { vendor-id: vendor-id })) ERR_NOT_FOUND)
    (map-set products
      { product-id: product-id }
      {
        name: name,
        category: category,
        vendor-id: vendor-id,
        carbon-footprint: carbon-footprint,
        carbon-offset-credits: carbon-offset-credits,
        sustainability-score: u0,
        current-stage: "raw-materials",
        owner: tx-sender,
        created-at: stacks-block-height
      }
    )
    (map-set product-lifecycle
      { product-id: product-id, stage: "raw-materials" }
      {
        timestamp: stacks-block-height,
        location: "origin",
        handler: tx-sender,
        verified: true
      }
    )
    (var-set next-product-id (+ product-id u1))
    (ok product-id)
  )
)

(define-public (update-lifecycle-stage
  (product-id uint)
  (new-stage (string-ascii 16))
  (location (string-ascii 64)))
  (let ((product (unwrap! (map-get? products { product-id: product-id }) ERR_NOT_FOUND)))
    (asserts! (or (is-eq tx-sender (get owner product))
                  (is-eq tx-sender CONTRACT_OWNER)) ERR_UNAUTHORIZED)
    (map-set products
      { product-id: product-id }
      (merge product { current-stage: new-stage })
    )
    (map-set product-lifecycle
      { product-id: product-id, stage: new-stage }
      {
        timestamp: stacks-block-height,
        location: location,
        handler: tx-sender,
        verified: true
      }
    )
    (ok true)
  )
)

(define-public (vote-green-rating (product-id uint) (rating uint))
  (begin
    (asserts! (and (>= rating u1) (<= rating u5)) ERR_INVALID_RATING)
    (asserts! (is-some (map-get? products { product-id: product-id })) ERR_NOT_FOUND)
    (let ((existing-vote (map-get? green-ratings { product-id: product-id, voter: tx-sender }))
          (current-totals (default-to { total-score: u0, vote-count: u0 }
                          (map-get? product-rating-totals { product-id: product-id }))))
      (if (is-some existing-vote)
        (let ((old-rating (get rating (unwrap-panic existing-vote))))
          (map-set green-ratings
            { product-id: product-id, voter: tx-sender }
            { rating: rating, timestamp: stacks-block-height }
          )
          (map-set product-rating-totals
            { product-id: product-id }
            {
              total-score: (+ (- (get total-score current-totals) old-rating) rating),
              vote-count: (get vote-count current-totals)
            }
          )
        )
        (begin
          (map-set green-ratings
            { product-id: product-id, voter: tx-sender }
            { rating: rating, timestamp: stacks-block-height }
          )
          (map-set product-rating-totals
            { product-id: product-id }
            {
              total-score: (+ (get total-score current-totals) rating),
              vote-count: (+ (get vote-count current-totals) u1)
            }
          )
        )
      )
      (ok true)
    )
  )
)

(define-public (transfer-product-ownership (product-id uint) (new-owner principal))
  (let ((product (unwrap! (map-get? products { product-id: product-id }) ERR_NOT_FOUND)))
    (asserts! (is-eq tx-sender (get owner product)) ERR_UNAUTHORIZED)
    (map-set products
      { product-id: product-id }
      (merge product { owner: new-owner })
    )
    (try! (update-lifecycle-stage product-id "transferred" "new-owner"))
    (ok true)
  )
)

(define-public (claim-carbon-credits (product-id uint))
  (let ((product (unwrap! (map-get? products { product-id: product-id }) ERR_NOT_FOUND))
        (current-credits (default-to { total-credits: u0 }
                         (map-get? user-carbon-offsets { user: tx-sender }))))
    (asserts! (is-eq tx-sender (get owner product)) ERR_UNAUTHORIZED)
    (asserts! (> (get carbon-offset-credits product) u0) ERR_NOT_FOUND)
    (map-set user-carbon-offsets
      { user: tx-sender }
      { total-credits: (+ (get total-credits current-credits) (get carbon-offset-credits product)) }
    )
    (map-set products
      { product-id: product-id }
      (merge product { carbon-offset-credits: u0 })
    )
    (ok (get carbon-offset-credits product))
  )
)

(define-public (verify-vendor-certification (vendor-id uint) (level uint))
  (let ((vendor (unwrap! (map-get? verified-vendors { vendor-id: vendor-id }) ERR_NOT_FOUND)))
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (map-set verified-vendors
      { vendor-id: vendor-id }
      (merge vendor { certification-level: level })
    )
    (ok true)
  )
)

(define-read-only (get-product-info (product-id uint))
  (map-get? products { product-id: product-id })
)

(define-read-only (get-lifecycle-stage (product-id uint) (stage (string-ascii 16)))
  (map-get? product-lifecycle { product-id: product-id, stage: stage })
)

(define-read-only (get-vendor-info (vendor-id uint))
  (map-get? verified-vendors { vendor-id: vendor-id })
)

(define-read-only (get-product-rating (product-id uint))
  (map-get? product-rating-totals { product-id: product-id })
)

(define-read-only (get-user-vote (product-id uint) (voter principal))
  (map-get? green-ratings { product-id: product-id, voter: voter })
)

(define-read-only (get-carbon-credits (user principal))
  (map-get? user-carbon-offsets { user: user })
)

(define-read-only (calculate-average-rating (product-id uint))
  (let ((totals (map-get? product-rating-totals { product-id: product-id })))
    (if (is-some totals)
      (let ((data (unwrap-panic totals)))
        (if (> (get vote-count data) u0)
          (some (/ (get total-score data) (get vote-count data)))
          none
        )
      )
      none
    )
  )
)
