// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        address priceFeed = helperConfig.getActiveNetworkConfig().priceFeed;
        
        console.log("Deployment chain ID:", block.chainid);
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

    function deployFundMe() external returns (FundMe, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        address priceFeed = helperConfig.getActiveNetworkConfig().priceFeed;
        
        console.log("Deployment chain ID:", block.chainid);
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
        
        return (fundMe, helperConfig);
    }
} 