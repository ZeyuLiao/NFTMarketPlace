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

    // 获取某个 NFT 合约地址
    function getCollection(uint256 index) public view returns (address) {
        return collections[index];
    }

    // 获取 某个NFT 合约的所有者
    function getCollectionOwner(
        address collection
    ) public view returns (address) {
        return Ownable(collection).owner();
    }

    // 获取某个 NFT 合约的 tokenURI
    function getCollectionTokenURI(
        address collection,
        uint256 tokenId
    ) public view returns (string memory) {
        return NFTCollection(collection).getTokenURI(tokenId);
    }
}
