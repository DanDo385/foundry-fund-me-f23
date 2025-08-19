// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "./DeployFundMe.s.sol";
import {DevOpsTools} from "foundry-devops/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 public constant SEND_VALUE = 0.1 ether; // 0.1 ETH  

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s ETH", SEND_VALUE);
    }
    
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe", 
            block.chainid
        );
        fundFundMe(mostRecentlyDeployed);
    }
}

contract WithdrawFundMe is Script {
    
    function withdrawFromFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Withdrew all funds from FundMe contract at %s", mostRecentlyDeployed);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe", block.chainid
        );
        withdrawFromFundMe(mostRecentlyDeployed);
    }
}
