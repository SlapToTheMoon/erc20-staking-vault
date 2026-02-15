// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken token;

    function setUp() public {
        token = new MyToken("MyToken", "MTK", 1_000 ether);
    }

    function testInitialMintToDeployer() public {
        assertEq(token.totalSupply(), 1_000 ether);
        assertEq(token.balanceOf(address(this)), 1_000 ether);
    }
}
