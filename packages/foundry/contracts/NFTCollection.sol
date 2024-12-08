// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTCollection is ERC721URIStorage {
    uint256 public tokenCounter;

    constructor(
        string memory name,
        string memory symbol,
        address owner,
        string memory ipfsUrl
    ) ERC721(name, symbol) {
        uint256 newTokenId = tokenCounter;
        _safeMint(owner, newTokenId);
        _setTokenURI(newTokenId, ipfsUrl);
        tokenCounter += 1;
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        return tokenURI(tokenId);
    }

    // 铸造一个新的 NFT
    function mintNFT(address to, string memory ipfsUrl) public {
        uint256 newTokenId = tokenCounter;
        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, ipfsUrl);
        tokenCounter += 1;
    }

    // 销毁一个 NFT
    function burnNFT(uint256 tokenId) public {
        _burn(tokenId);
    }

    // 转移 NFT
    function transferNFT(address to, uint256 tokenId) public {
        safeTransferFrom(msg.sender, to, tokenId);
    }
}
