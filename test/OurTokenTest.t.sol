// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployOurToken;

    address furkan = makeAddr("furkan");
    address yusuf = makeAddr("yusuf");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployOurToken = new DeployOurToken();
        ourToken = deployOurToken.run();

        vm.prank(msg.sender);
        ourToken.transfer(furkan, STARTING_BALANCE);
    }

    function testFurkanBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(furkan));
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;
        uint256 transferAmount = 500;

        vm.prank(furkan);
        ourToken.approve(yusuf, initialAllowance);

        vm.prank(yusuf);
        ourToken.transferFrom(furkan, yusuf, transferAmount);

        assertEq(ourToken.balanceOf(yusuf), transferAmount);
        assertEq(ourToken.balanceOf(furkan), STARTING_BALANCE - transferAmount);
    }
}
