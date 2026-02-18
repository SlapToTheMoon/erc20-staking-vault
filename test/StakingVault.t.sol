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
    function testStakeUpdatesBalances() public {
    // arrange: give this test contract tokens & approve vault
    token.approve(address(vault), 100 ether);

    // act
    vault.stake(100 ether);

    // assert: vault now holds tokens
    assertEq(token.balanceOf(address(vault)), 100 ether);
    // user’s stake balance updated
    assertEq(vault.balanceOf(address(this)), 100 ether);
    // global totalStaked updated
    assertEq(vault.totalStaked(), 100 ether);
}

function testUnstakeReducesBalancesAndReturnsTokens() public {
    // arrange: stake 100 ether first
    token.approve(address(vault), 100 ether);
    vault.stake(100 ether);

    // act: unstake 40 ether
    vault.unstake(40 ether);

    // assert: vault now holds 60, user got 40 back
    assertEq(token.balanceOf(address(vault)), 60 ether);
    assertEq(vault.balanceOf(address(this)), 60 ether);
    assertEq(vault.totalStaked(), 60 ether);

    // user started with 1_000, staked 100, then unstaked 40 → 940
    assertEq(token.balanceOf(address(this)), 940 ether);
}

}
