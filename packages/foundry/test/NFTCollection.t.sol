// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/NFTCollection.sol"; // 导入合约文件

contract NFTCollectionTest is Test {
    NFTCollection public nftCollection;
    address public owner;
    address public bidder1;
    address public bidder2;

    uint256 public tokenId;
    string public ipfsUrl = "ipfs://sample-uri";

    function setUp() public {
        // 设置初始账户
        owner = address(0x1);
        bidder1 = address(0x2);
        bidder2 = address(0x3);

        // 部署 NFT 合约
        nftCollection = new NFTCollection("TestNFT", "TNFT", owner, ipfsUrl);
        tokenId = 0; // 假设NFT的ID为0
    }

    function testListNFT() public {
        uint256 startingPrice = 1 ether;
        uint256 duration = 1 days;

        // 授权NFT列出
        vm.startPrank(owner);
        nftCollection.listNFT(startingPrice, duration);
        vm.stopPrank();

        // 验证NFT是否被列出
        bool listed = nftCollection.isNFTListed();
        assertTrue(listed, "NFT should be listed for auction");
    }

    function testBid() public {
        uint256 startingPrice = 1 ether;
        uint256 duration = 1 days;

        // 列出NFT拍卖
        vm.startPrank(owner);
        nftCollection.listNFT(startingPrice, duration);
        vm.stopPrank();

        // 执行第一次出价
        vm.deal(bidder1, 2 ether); // 给 bidder1 足够的ETH
        vm.startPrank(bidder1);
        nftCollection.bid{value: 2 ether}();
        vm.stopPrank();

        // 验证最高出价者
        address highestBidder = nftCollection.getHighestBidder();
        uint256 highestBid = nftCollection.getHighestBid();
        assertEq(highestBidder, bidder1, "Highest bidder should be bidder1");
        assertEq(highestBid, 2 ether, "Highest bid should be 2 ether");
    }

    function testEndAuction() public {
        uint256 startingPrice = 1 ether;
        uint256 duration = 1 days;

        // 列出NFT拍卖
        vm.startPrank(owner);
        nftCollection.listNFT(startingPrice, duration);
        vm.stopPrank();

        // 执行出价
        vm.deal(bidder1, 3 ether);
        vm.startPrank(bidder1);
        nftCollection.bid{value: 2 ether}();
        vm.stopPrank();

        // 结束拍卖
        vm.warp(block.timestamp + 2 days); // 模拟时间流逝
        vm.startPrank(owner);
        nftCollection.endAuction();
        vm.stopPrank();

        // 验证NFT转移
        address highestBidder = nftCollection.getHighestBidder();
        assertEq(
            highestBidder,
            bidder1,
            "Highest bidder should receive the NFT"
        );
    }
}
