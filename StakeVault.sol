// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract StakingDapp {
    struct User {
        uint stakedAmount;
        uint lockPeriod;
        uint startTime;
        bool stakingStatus;
    }

    mapping(address => User) public users;
    uint public totalStakingETH;
    uint public totalReward; // total rewards paid

    event Staked(address indexed user, uint indexed amount, uint time);
    event RewardPaid(address indexed user, uint indexed amount);
    event Unstaked(address indexed user, uint indexed amount, uint indexed reward);

    // Stake ETH with a lock period of 30, 60, or 90 days
    function stake(uint _lockPeriodInDays) public payable {
        require(
            _lockPeriodInDays == 30 || _lockPeriodInDays == 60 || _lockPeriodInDays == 90,
            "Lock period must be 30, 60, or 90 days"
        );
        require(msg.value >= 0.1 ether, "Minimum stake is 0.1 ETH");

        users[msg.sender] = User({
            stakedAmount: msg.value,
            lockPeriod: _lockPeriodInDays * 1 days, // store in seconds
            startTime: block.timestamp,
            stakingStatus: true
        });

        totalStakingETH += msg.value;
        emit Staked(msg.sender, msg.value, block.timestamp);
    } 

    // Internal: calculate staking reward based on lock period
    function calculateReward() private view returns (uint) {
        User storage u = users[msg.sender];
        uint rate;

        if (u.lockPeriod == 30 days) {
            rate = 5;  // 5%
        } else if (u.lockPeriod == 60 days) {
            rate = 8;  // 8%
        } else if (u.lockPeriod == 90 days) {
            rate = 12; // 12%
        } else {
            rate = 0;  // fallback
        }

        return (u.stakedAmount * rate) / 100;
    }

    // Claim reward after lock period ends
    function claimReward() public {
        User storage u = users[msg.sender];
        require(block.timestamp >= u.startTime + u.lockPeriod, "Lock period not finished");

        uint reward = calculateReward();
        require(reward > 0, "No rewards available");

        (bool sent, ) = payable(msg.sender).call{value: reward}("");
        require(sent, "Reward transfer failed");

        totalReward += reward;
        emit RewardPaid(msg.sender, reward);
    }

    // Unstake: withdraw staked amount + rewards
    function unstake() public {
        User storage u = users[msg.sender];
        require(u.stakingStatus, "No active stake"); 
        require(block.timestamp >= u.startTime + u.lockPeriod, "Lock period not finished");

        uint staked = u.stakedAmount;
        uint reward = calculateReward();
        require(reward > 0, "No rewards available");

        uint totalPayout = staked + reward;

        (bool sent, ) = payable(msg.sender).call{value: totalPayout}("");
        require(sent, "Reward transfer failed");

        totalReward += reward;
        totalStakingETH -= staked;

        u.stakedAmount = 0;
        u.stakingStatus = false;

        emit Unstaked(msg.sender, staked, reward);
    }
}
