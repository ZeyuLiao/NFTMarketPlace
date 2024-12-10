// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/NFTCollection.sol";

contract NFTCollectionTest is Test {
    NFTCollection public nft;
    address public owner;
    address public buyer;

    function setUp() public {
        // 设置测试账户
        owner = address(1);
        buyer = address(2);

        // 为账户添加测试资金
        vm.deal(owner, 100 ether);
        vm.deal(buyer, 100 ether);

        // 部署合约并铸造一个初始 NFT
        nft = new NFTCollection("Test NFT", "TNFT", owner, "ipfs://test-uri");
    }

    function testMintedNFT() public {
        // 检查 NFT 初始状态
        assertEq(nft.tokenCounter(), 1);
        assertEq(nft.ownerOf(0), owner);
        assertEq(nft.tokenURI(0), "ipfs://test-uri");
    }

    function testListNFT() public {
        vm.prank(owner); // 模拟 owner 调用
        nft.listNFT(0, 1 ether);

        (uint256 price, address seller) = nft.listings(0);

        // 验证 NFT 列表状态
        assertEq(price, 1 ether);
        assertEq(seller, owner);
    }

    function testBuyNFT() public {
        // 上架 NFT
        vm.prank(owner);
        nft.listNFT(0, 1 ether);

        // 验证买家余额和卖家余额变化
        uint256 buyerInitialBalance = buyer.balance;
        uint256 ownerInitialBalance = owner.balance;

        console.log("Buyer balance before: ", buyer.balance);

        vm.prank(buyer);
        nft.buyNFT{value: 1 ether}(0);

        console.log("Buyer balance after: ", buyer.balance);

        // 验证 NFT 新所有者
        assertEq(nft.ownerOf(0), buyer);

        // 验证以太币转账
        assertEq(owner.balance, ownerInitialBalance + 1 ether);
        assertEq(buyer.balance, buyerInitialBalance - 1 ether);

        // 验证 Listing 被清除
        (uint256 price, address seller) = nft.listings(0);
        assertEq(price, 0);
        assertEq(seller, address(0));
    }

    function testCancelListing() public {
        // 上架 NFT
        vm.prank(owner);
        nft.listNFT(0, 1 ether);

        // 取消上架
        vm.prank(owner);
        nft.cancelListing(0);

        // 验证 Listing 被清除
        (uint256 price, address seller) = nft.listings(0);
        assertEq(price, 0);
        assertEq(seller, address(0));
    }

    function testCannotBuyWithoutEnoughFunds() public {
        // 上架 NFT
        vm.prank(owner);
        nft.listNFT(0, 1 ether);

        // 模拟买家尝试支付不足金额
        vm.prank(buyer);
        vm.expectRevert("Incorrect price sent");
        nft.buyNFT{value: 0.5 ether}(0);
    }

    function testCannotBuyOwnNFT() public {
        // 上架 NFT
        vm.prank(owner);
        nft.listNFT(0, 1 ether);

        // 模拟卖家尝试购买自己的 NFT
        vm.prank(owner);
        vm.expectRevert("Seller cannot buy their own NFT");
        nft.buyNFT{value: 1 ether}(0);
    }

    function testCannotCancelListingNotOwner() public {
        // 上架 NFT
        vm.prank(owner);
        nft.listNFT(0, 1 ether);

        // 模拟非所有者取消上架
        vm.prank(buyer);
        vm.expectRevert("You are not the seller");
        nft.cancelListing(0);
    }
}
