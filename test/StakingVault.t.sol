// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyToken.sol";
import "../src/StakingVault.sol";

contract StakingVaultTest is Test {
    MyToken token;
    StakingVault vault;

    function setUp() public {
        token = new MyToken("MyToken", "MTK", 1_000 ether);
        vault = new StakingVault(address(token));
    }

    function testInitialState() public {
        assertEq(address(vault.stakingToken()), address(token));
        assertEq(vault.totalStaked(), 0);
        assertEq(vault.balanceOf(address(this)), 0);
    }
}
