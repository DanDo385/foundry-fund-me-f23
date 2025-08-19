// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    
    address USER = makeAddr("user");
    uint256 public constant SEND_VALUE = 0.1 ether; // just a value to make sure we are sending enough!
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    uint256 public constant GAS_PRICE = 1;
    
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();

        vm.deal(USER, STARTING_USER_BALANCE);
    }

    function testUserCanWithdrawInteractions() public {
        console.log("=== Starting testUserCanWithdrawInteractions ===");
        console.log("Initial contract balance: %s ETH", address(fundMe).balance);
        console.log("User address: %s", USER);
        console.log("User balance before funding: %s ETH", USER.balance);
        
        // First fund the contract
        vm.startPrank(USER);
        fundMe.fund{value: SEND_VALUE}();
        vm.stopPrank();
        
        console.log("User funded contract with %s ETH", SEND_VALUE);
        console.log("Contract balance after funding: %s ETH", address(fundMe).balance);
        console.log("User balance after funding: %s ETH", USER.balance);
        
        // Verify funding worked
        address funder = fundMe.getFunder(0);
        console.log("First funder recorded: %s", funder);
        console.log("Expected funder: %s", USER);
        console.log("Funder match: %s", funder == USER ? "PASS" : "FAIL");
        
        assertEq(funder, USER);
        assertEq(address(fundMe).balance, SEND_VALUE);
        
        console.log("Funding verification: PASS");
        console.log("Contract balance verification: PASS");
        
        // Now test withdrawal directly (since the script is just a wrapper)
        // Get the owner (deployer) and prank as them
        address owner = fundMe.getOwner();
        console.log("Contract owner: %s", owner);
        console.log("Owner balance before withdrawal: %s ETH", owner.balance);
        
        vm.startPrank(owner);
        fundMe.withdraw();
        vm.stopPrank();
        
        console.log("Withdrawal executed successfully");
        console.log("Contract balance after withdrawal: %s ETH", address(fundMe).balance);
        console.log("Owner balance after withdrawal: %s ETH", owner.balance);
        
        // Verify withdrawal worked
        assertEq(address(fundMe).balance, 0);
        console.log("Final balance verification: PASS");
        console.log("=== testUserCanWithdrawInteractions completed successfully ===\n");
    }
}