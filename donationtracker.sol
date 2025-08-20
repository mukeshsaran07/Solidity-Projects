// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DonationTracker {
    struct Donor {
        string name;
        uint256 amount;
        address wallet;
    }

    // Donor storage
    mapping(address => Donor) public donors;
    address[] public donorList;

    uint256 public totalDonated;
    uint256 public minDonation = 2 ether;         // configurable minimum donation
    uint256 public maxWithdrawal = 5 ether;       // maximum per withdrawal (configurable)
    uint256 public withdrawalCooldown = 1 days;   // cooldown between withdrawals (configurable)
    uint256 public lastWithdrawalTime;

    // Ownership
    address public owner;

    // Events
    event DonationMade(address indexed donor, uint256 amount, string name);
    event FundWithdrawn(address indexed owner, uint256 amount);
    event MinDonationUpdated(uint256 oldValue, uint256 newValue);
    event MaxWithdrawalUpdated(uint256 oldValue, uint256 newValue);
    event CooldownUpdated(uint256 oldValue, uint256 newValue);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Donate with name; tracks unique donors in donorList
    function donate(string memory _name) public payable {
        require(msg.value >= minDonation, "Below minimum donation");

        // New donor?
        if (donors[msg.sender].wallet == address(0)) {
            donors[msg.sender] = Donor(_name, msg.value, msg.sender);
            donorList.push(msg.sender);
        } else {
            // Update existing donor
            donors[msg.sender].amount += msg.value;
        }

        totalDonated += msg.value;
        emit DonationMade(msg.sender, msg.value, _name);
    }


    // Withdraw with limits and cooldown protection
    function withdrawFund(uint256 amount) public onlyOwner {
        require(amount > 0, "Amount = 0");
        require(amount <= address(this).balance, "Insufficient contract balance");
        require(amount <= maxWithdrawal, "Exceeds max withdrawal");
        require(block.timestamp >= lastWithdrawalTime + withdrawalCooldown, "Cooldown active");

        // Effects first (reentrancy-safe)
        lastWithdrawalTime = block.timestamp;

        // Interaction
        (bool ok, ) = payable(owner).call{value: amount}("");
        require(ok, "Transfer failed");

        emit FundWithdrawn(owner, amount);
    }



    // Returns all donor addresses (iterate off-chain to read details)
    function getAllDonors() external view returns (address[] memory) {
        return donorList;
    }

    // --- Admin configuration ---

    function setMinDonation(uint256 newMin) external onlyOwner {
        emit MinDonationUpdated(minDonation, newMin);
        minDonation = newMin;
    }

    function setMaxWithdrawal(uint256 newMax) external onlyOwner {
        emit MaxWithdrawalUpdated(maxWithdrawal, newMax);
        maxWithdrawal = newMax;
    }

    function setWithdrawalCooldown(uint256 newCooldown) external onlyOwner {
        emit CooldownUpdated(withdrawalCooldown, newCooldown);
        withdrawalCooldown = newCooldown;
    }
}
