// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EthWallet {
    // Track user balances
    mapping(address => uint) public balances;

    event Deposit(address indexed user, uint amount);
    event Withdraw(address indexed user, uint amount);

    
    function getUserBalance() public view returns(uint){
        return address(msg.sender).balance;
        // total ETH balance of the user's own wallet
    }


    function deposit() public payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value); 
    }

    
    function withdraw(uint _amount) public payable {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, _amount); // log withdraw
    }

    // Get the amount of ETH the user deposited into this contract
    function getContractBalance() public view returns(uint){
        return balances[msg.sender];
    }
}
