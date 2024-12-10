// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTCollection is ERC721URIStorage {
    uint256 public tokenCounter;

    struct Listing {
        uint256 price;
        address seller;
    }

    mapping(uint256 => Listing) public listings;

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

    // List NFT for sale
    function listNFT(uint256 tokenId, uint256 price) external {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner");
        require(price > 0, "Price must be greater than 0");

        listings[tokenId] = Listing({price: price, seller: msg.sender});
    }

    // Cancel listing
    function cancelListing(uint256 tokenId) external {
        require(
            listings[tokenId].seller == msg.sender,
            "You are not the seller"
        );

        delete listings[tokenId];
    }

    // Purchase NFT
    function buyNFT(uint256 tokenId) external payable {
        Listing memory listing = listings[tokenId];

        require(listing.price > 0, "NFT is not listed for sale");
        require(msg.value == listing.price, "Incorrect price sent");
        require(
            listing.seller != msg.sender,
            "Seller cannot buy their own NFT"
        );

        // Transfer NFT
        _transfer(listing.seller, msg.sender, tokenId);

        // Pay the seller
        payable(listing.seller).transfer(msg.value);

        // Remove Listing
        delete listings[tokenId];
    }

    // Get NFT price
    function getNFTPrice(uint256 tokenId) external view returns (uint256) {
        return listings[tokenId].price;
    }

    // Check if NFT is listed for sale
    function isNFTListed(uint256 tokenId) external view returns (bool) {
        return listings[tokenId].price > 0;
    }
}
