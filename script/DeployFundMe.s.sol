// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        vm.startBroadcast();
        
        // Deploy mock price feed with ETH price of $2000
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 2000e8);
        
        // Deploy FundMe with mock price feed
        FundMe fundMe = new FundMe(address(mockPriceFeed));
        
        vm.stopBroadcast();
        return fundMe;
    }
} 