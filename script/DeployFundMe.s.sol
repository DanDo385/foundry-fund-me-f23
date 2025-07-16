// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        console.log("Deployment chain ID:", block.chainid);
        
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory activeNetworkConfig = helperConfig.getActiveNetworkConfig();
        address priceFeed = activeNetworkConfig.priceFeed;
        
        console.log("Initial price feed from config:", priceFeed);
        
        // Always deploy a mock price feed for testing
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 2000e8);
        priceFeed = address(mockPriceFeed);
        vm.stopBroadcast();
        console.log("Using mock price feed:", priceFeed);
        
        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();
        
        console.log("FundMe deployed at:", address(fundMe));
        console.log("Final price feed address:", priceFeed);
        
        return fundMe;
    }
} 