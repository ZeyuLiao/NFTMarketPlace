//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./DeployHelpers.s.sol";
import {DeployFactory} from "./DeployFactory.s.sol";
import {DeployNFT} from "./DeployNFT.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    function run() external {
        DeployFactory deployFactory = new DeployFactory();
        deployFactory.run();

        DeployNFT deployNFT = new DeployNFT();
        deployNFT.run();
    }
}
