//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/NFTCollection.sol";
import "./DeployHelpers.s.sol";

contract DeployNFT is ScaffoldETHDeploy {
    // use `deployer` from `ScaffoldETHDeploy`

    function run() external ScaffoldEthDeployerRunner {
        NFTCollection nft = new NFTCollection(
            "BLACKNFT",
            "BNFT",
            deployer,
            "ipfs://QmY5gUSexQwUvLgughEoYDQeWmxgPKEUaCPZhyU66CKjs3"
        );
    }
}
