# Solidity Projects Collection

This repository contains multiple smart contracts built with **Solidity (0.8.19)**.  
Each project demonstrates different blockchain use-cases such as wallets, crowdfunding, voting, marketplaces, and staking.

---

## 📌 Projects Overview

### 1. EthWallet
A simple Ethereum wallet that allows users to **deposit** and the owner to **withdraw** ETH.

#### Features:
- Deposit ETH securely.
- Only the owner can withdraw ETH.
- Events for transparency.

#### Events:
- `Deposit(address indexed user, uint amount)`
- `Withdraw(address indexed owner, uint amount)`

---

### 2. DonationTracker
A crowdfunding smart contract where donors can contribute ETH, and the owner manages withdrawals.

#### Features:
- Accepts donations from anyone.
- Owner can withdraw accumulated funds.
- Tracks donor list and contributions.
- Getter function to view all donors.
- Security considerations like **onlyOwner** checks.

#### Events:
- `DonationReceived(address indexed donor, uint amount)`
- `FundsWithdrawn(address indexed owner, uint amount)`

---

### 3. VotingSystem
A decentralized voting system for elections with candidate and voter management.

#### Features:
- Predefined candidates.
- One vote per address.
- Tracks total votes and voters.
- Allows only the owner to declare results.
- Handles **tie situations**.
- Anyone can view results.

#### Events:
- `VoteCast(address indexed voter, string candidate)`
- `WinnerDeclared(string[] winners, uint maxVotes)`

---

### 4. ETHMart (Digital Marketplace)
A decentralized marketplace where sellers can list products, and buyers can purchase them with ETH.

#### Features:
- Sellers can add products with name, price, and quantity.
- Buyers can purchase available products.
- Maintains **seller dashboards** (list of product IDs).
- Tracks **order history** for each buyer.
- ETH transfers directly to sellers.

#### Events:
- `ProductAdded(uint productId, address indexed seller, string name, uint price, uint quantity)`
- `ProductPurchased(address indexed buyer, uint productId, uint price)`

---

### 5. StakeVault (Staking DApp)
A staking platform where users can lock ETH for rewards based on the lock period.

#### Features:
- Lock ETH for **30, 60, or 90 days**.
- Rewards based on staking duration (5%, 8%, 12%).
- Claim rewards after lock period ends.
- Unstake to withdraw both principal + rewards.
- Tracks **total staked ETH** and **total rewards paid**.

#### Events:
- `Staked(address indexed user, uint amount, uint time)`
- `RewardPaid(address indexed user, uint amount)`
- `Unstaked(address indexed user, uint amount, uint reward)`

---

## 🛠️ Tech Stack
- **Solidity 0.8.19**
- **Hardhat / Remix IDE** for testing
- **Ethereum (ETH)** for transactions

---

## 🚀 How to Use
1. Deploy the contracts using **Remix IDE** or **Hardhat**.
2. Interact with functions:
   - Deposit / Withdraw (EthWallet)
   - Donate / Withdraw (DonationTracker)
   - Vote / View Winner (VotingSystem)
   - Add Product / Buy Product (ETHMart)
   - Stake / Claim Reward / Unstake (StakeVault)

---

## 📜 License
This repository is licensed under the **MIT License**.
