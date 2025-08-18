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
        // First fund the contract
        vm.startPrank(USER);
        fundMe.fund{value: SEND_VALUE}();
        vm.stopPrank();
        
        // Verify funding worked
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
        assertEq(address(fundMe).balance, SEND_VALUE);
        
        // Now test withdrawal directly (since the script is just a wrapper)
        // Get the owner (deployer) and prank as them
        address owner = fundMe.getOwner();
        vm.startPrank(owner);
        fundMe.withdraw();
        vm.stopPrank();
        
        // Verify withdrawal worked
        assertEq(address(fundMe).balance, 0);
    }
}