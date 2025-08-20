// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DigitalMarketplace {
    struct Product {
        uint id; // not needed but helpful for frontend
        address seller;
        string name;
        uint price;
        uint quantity;
    }

    mapping(uint => Product) public productList; 
    mapping(address => uint[]) public sellerProductIds; // to set seller dashboard
    uint public productCount = 0;

    struct OrderHistory {
        uint productId;
        string productName;
        uint price;
        address seller; 
    }

    mapping(address => OrderHistory[]) public orderList; 

    // ------------------ Events ------------------
    event ProductAdded(uint indexed productId, address indexed seller, string name, uint price, uint quantity);
    event ProductBought(uint indexed productId, address indexed buyer, address indexed seller, uint price);

    // ------------------ Functions ------------------
    function addProduct(string memory _name, uint _price, uint _quantity) public {
        require(_price > 0 && _quantity > 0, "Price and quantity must be greater than zero");

        productCount++;
        productList[productCount] = Product(productCount, msg.sender, _name, _price, _quantity);
        sellerProductIds[msg.sender].push(productCount);

        emit ProductAdded(productCount, msg.sender, _name, _price, _quantity);
    }

    function buyProduct(uint _id) public payable {
        require(_id > 0 && _id <= productCount, "Invalid product ID");
        require(productList[_id].quantity > 0, "Product is out of stock");
        require(msg.value == productList[_id].price, "Incorrect payment amount");

        productList[_id].quantity--;
        payable(productList[_id].seller).transfer(msg.value);

        orderList[msg.sender].push(
            OrderHistory(_id, productList[_id].name, msg.value, productList[_id].seller)
        );

        emit ProductBought(_id, msg.sender, productList[_id].seller, msg.value);
    }
}
