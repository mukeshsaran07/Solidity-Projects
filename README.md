# Solidity-Projects
A collection of Solidity smart contracts (ETH wallet, donation tracker, voting system, marketplace, staking DApp) — with more projects to come.

# EthWallet 🦊

A simple Ethereum wallet smart contract written in Solidity.  
This contract allows users to **deposit, withdraw, and track their ETH balances** inside the contract.  
It demonstrates the basics of managing funds on the Ethereum blockchain.

---

## ✨ Features
- Deposit ETH into the contract.  
- Withdraw ETH from the contract.  
- Track deposited balances per user.  
- Check external wallet balance (from `msg.sender`).  
- Emits events on deposits and withdrawals for better transparency.  

---

## 📖 Functions

- `deposit()` → Deposit ETH into the contract.  
- `withdraw(uint _amount)` → Withdraw ETH from your deposited balance.  
- `getUserBalance()` → Returns the ETH balance of your external wallet.  
- `getContractBalance()` → Returns how much ETH you have deposited into this contract.  

---

## 🛠️ How to Run
1. Open the contract in [Remix IDE](https://remix.ethereum.org/).  
2. Compile using **Solidity ^0.8.19**.  
3. Deploy the contract to a local blockchain (Ganache/Hardhat) or a testnet (Goerli, Sepolia).  
4. Interact with the functions:  
   - Use the **deposit** function with some ETH value.  
   - Call **withdraw** with an amount (must be ≤ your deposited balance).  
   - Check balances with **getUserBalance** and **getContractBalance**.  

---

## 📡 Events
- `Deposit(address user, uint amount)` – Triggered when a user deposits ETH.  
- `Withdraw(address user, uint amount)` – Triggered when a user withdraws ETH.  

---

## 📜 License
This project is licensed under the **MIT License**.  

