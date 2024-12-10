// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./NFTCollection.sol";

contract NFTFactory {
    address[] public collections;

    constructor() {}

    // 部署一个新的 NFT 集合合约
    function createNFTCollection(
        string memory name,
        string memory symbol,
        address owner,
        string memory ipfsUrl
    ) public {
        NFTCollection newCollection = new NFTCollection(
            name,
            symbol,
            owner,
            ipfsUrl
        );
        collections.push(address(newCollection));
    }

    // 获取所有 NFT 合约地址
    function getAllCollections() public view returns (address[] memory) {
        return collections;
    }
}
