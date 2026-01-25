A blockchain-based platform for tracking eco-friendly home materials from origin to your doorstep

## 🚀 Overview

The Sustainable Home Supply Chain Tracker is a Clarity smart contract that provides transparency and authenticity for eco-friendly home goods. Track your furniture, fixtures, and materials through their complete lifecycle while earning carbon offset credits! 🌍

## ✨ Key Features

### 🔐 NFT-Style Product Authentication
- Unique product registration with sustainability records
- Immutable authenticity verification
- Owner-based transfer system

### 📈 Lifecycle Tracking System
- **Raw Materials** → **Factory** → **Home** journey tracking
- Location-based verification at each stage
- Handler authentication for each transition

### 🌿 Carbon Offset Credits
- Automatic carbon credit tagging for eco-friendly products
- Claimable credits for product owners
- Personal carbon offset tracking

### ✅ Verified Vendor Registry  
- Certification-based vendor verification
- Specialty categorization
- Trust level management

### 🗳️ Green Rating DAO
- Community-driven sustainability ratings (1-5 stars)
- Democratic voting system for product quality
- Average rating calculations

### 🎁 Product Donation System
- Charitable product donations to organizations
- Ownership transfer with lifecycle updates
- Donation history tracking

### 💰 Carbon Credit Marketplace
- Decentralized trading platform for carbon offset credits
- Peer-to-peer credit exchanges with STX payments
- Transparent trade history and escrow-free transactions

## �️ Contract Functions

### 📦 Product Management

#### `register-product`
Register a new sustainable product with full sustainability metrics
```clarity
(register-product "Bamboo Table" "Furniture" u1 u50 u25)
```

#### `update-lifecycle-stage`  
Update product journey stage with location verification
```clarity
(update-lifecycle-stage u1 "factory" "Sustainable Factory Inc")
```

#### `transfer-product-ownership`
Transfer product ownership with automatic lifecycle update
```clarity
(transfer-product-ownership u1 'SP2ABC...)
```

#### `donate-product`
Donate a product to a charitable organization
```clarity
(donate-product u1 'SPCHARITY...)
```

### 🏭 Vendor Operations

#### `register-vendor`
Register as a verified sustainable vendor
```clarity
(register-vendor "EcoWood Co" "Sustainable Furniture")
```

#### `verify-vendor-certification`
Admin function to set vendor certification levels
```clarity  
(verify-vendor-certification u1 u3)
```

### 🌟 Rating & Credits

#### `vote-green-rating`
Vote on product sustainability (1-5 rating scale)
```clarity
(vote-green-rating u1 u5)
```

#### `claim-carbon-credits`  
Claim carbon offset credits from owned products
```clarity
(claim-carbon-credits u1)
```

### 📊 Read-Only Functions

- `get-product-info` - Get complete product details
- `get-lifecycle-stage` - Get specific stage information  
- `get-vendor-info` - Get vendor details and certification
- `get-product-rating` - Get voting totals for products
- `get-user-vote` - Check individual user votes
- `get-product-donation` - Get donation details for products
- `get-carbon-credits` - Get user's total carbon credits
- `calculate-average-rating` - Get calculated average rating

## 🏗️ Getting Started

### Prerequisites
- Clarinet CLI installed
- Stacks wallet for deployment

### Installation

1. **Clone and setup**
   ```bash
   git clone <repository-url>
   cd sustainable-home-supply-chain-tracker
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Test the contract**
   ```bash
   clarinet check
   npm test
   ```

### 🎯 Usage Examples

#### Register as Vendor
```bash
clarinet console
(contract-call? .Sustainable-Home-Supply-Chain-Tracker register-vendor "Green Materials Co" "Flooring")
```

#### Track Product Journey
```bash
# Register product  
(contract-call? .Sustainable-Home-Supply-Chain-Tracker register-product "Cork Flooring" "Flooring" u1 u30 u15)

# Update to factory stage
(contract-call? .Sustainable-Home-Supply-Chain-Tracker update-lifecycle-stage u1 "factory" "Eco Factory Portugal")

# Update to delivered stage  
(contract-call? .Sustainable-Home-Supply-Chain-Tracker update-lifecycle-stage u1 "delivered" "Customer Home")
```

#### Community Rating
```bash
# Vote on product sustainability
(contract-call? .Sustainable-Home-Supply-Chain-Tracker vote-green-rating u1 u4)

# Check average rating
(contract-call? .Sustainable-Home-Supply-Chain-Tracker calculate-average-rating u1)
```

## 🔒 Security Features

- Owner-only product transfers
- Donation authorization restricted to product owners
- Admin-controlled vendor verification
- Input validation for ratings (1-5 scale)
- Unauthorized access protection
- Vote update capabilities (users can change their votes)

## 🌍 Environmental Impact

Each product tracks:
- 🏭 **Carbon Footprint**: Total emissions during production
- 🌱 **Carbon Offset Credits**: Environmental compensation credits
- ⭐ **Community Ratings**: Crowd-sourced sustainability scores
- 🎁 **Donation Tracking**: Charitable giving and product redistribution
- 📍 **Supply Chain Transparency**: Full journey tracking

## 📋 Contract Data

- **Products**: 257 lines of comprehensive tracking
- **Vendors**: Verified sustainability partners
- **Lifecycle**: Complete journey documentation
- **Ratings**: Democratic sustainability assessment
- **Credits**: Personal environmental impact tracking
- **Donations**: Product donation records for social impact

## 🤝 Contributing

This is an MVP implementation focused on core functionality. Future enhancements welcome! 

## 📄 License

Open source - build a more sustainable future together! 🌱

---

*Built with 💚 for a sustainable tomorrow*

### 🚨 Product Recall System
- Authorized recall initiation for safety and quality control
- Automatic marketplace listing deactivation
- Lifecycle tracking for recall events
- Transparent recall status verification

### 📦 Product Management

#### `initiate-product-recall`
Initiate a product recall with reason and automatic safety measures
```clarity
(initiate-product-recall u1 "Quality Issue Detected")
```

#### `set-product-warranty`
Establish warranty coverage for products with customizable duration and type
```clarity
(set-product-warranty u1 u1440 "full-coverage")
```

#### `file-warranty-claim`
Submit warranty claims during active coverage period
```clarity
(file-warranty-claim u1 "Manufacturing Defect")
```

#### `resolve-warranty-claim`
Process and approve/deny warranty claims by product owners
```clarity
(resolve-warranty-claim u1 true)
```

### 📊 Read-Only Functions

- `is-product-recalled` - Check if a product has been recalled
- `get-product-warranty` - Retrieve warranty details for products
- `get-warranty-claim` - Get specific warranty claim information
- `is-warranty-active` - Verify current warranty status and validity

## 🔒 Security Features

- Recall authorization for owners and admins only
- Automatic prevention of recalled product sales
- Warranty management restricted to product owners
- Claim resolution limited to product owners
- Time-based warranty expiration validation

## 🌍 Environmental Impact

Each product tracks:
- 🚨 **Recall Status**: Safety and quality assurance mechanisms
- 🛡️ **Warranty Coverage**: Comprehensive protection and support tracking

## 📋 Contract Data

- **Recalls**: Authorized product recall tracking and marketplace protection
- **Warranties**: Product warranty management with claims processing

### 🌱 Carbon Credit Retirement
- Permanent retirement of carbon offset credits for verifiable offsetting
- User-controlled environmental impact commitment
- Transparent retirement tracking and balance management

### 🌟 Rating & Credits

#### `retire-carbon-credits`
Retire carbon credits to permanently offset emissions
```clarity
(retire-carbon-credits u10)
```

### 📊 Read-Only Functions

- `get-retired-carbon-credits` - Get user's total retired carbon credits

## 🌍 Environmental Impact

Each product tracks:
- 🌱 **Retired Credits**: Permanent carbon offsetting commitments

## 📋 Contract Data

- **Retirements**: User-initiated carbon credit retirement for environmental accountability
