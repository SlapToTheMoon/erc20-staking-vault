// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyToken.sol";

/// @title MyTokenTest
/// @notice Unit tests for the MyToken ERC-20 contract.
/// @dev Verifies that the constructor mints the full initial supply to the deployer and that
///      the ERC-20 invariant `totalSupply == balanceOf(deployer)` holds immediately after deployment.
contract MyTokenTest is Test {
    MyToken token;

    /// @notice Deploys MyToken with a 1,000-token initial supply before each test.
    function setUp() public {
        token = new MyToken("MyToken", "MTK", 1_000 ether);
    }

    /// @dev Verifies that the deployer (this test contract) receives the entire initial supply
    ///      and that totalSupply equals that amount with no tokens elsewhere.
    function testInitialMintToDeployer() public {
        assertEq(token.totalSupply(), 1_000 ether);
        assertEq(token.balanceOf(address(this)), 1_000 ether);
    }
}
