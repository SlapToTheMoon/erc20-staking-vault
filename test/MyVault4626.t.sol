// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyToken.sol";
import "../src/MyVault4626.sol";

/// @title MyVault4626Test
/// @notice Unit tests for the MyVault4626 ERC-4626 tokenised vault.
/// @dev The test contract owns the full 1,000 MTK initial supply and uses it as the depositor.
///      Tests verify the ERC-4626 standard's core invariants: asset address, share token metadata,
///      deposit share issuance, and asset accounting.
contract MyVault4626Test is Test {
    MyToken asset;
    MyVault4626 vault;

    /// @notice Deploys MyToken (1,000 MTK initial supply) and MyVault4626 before each test.
    function setUp() public {
        asset = new MyToken("MyToken", "MTK", 1_000 ether);
        vault = new MyVault4626(asset);
    }

    /// @dev Verifies that the vault is wired to the correct underlying asset after deployment,
    ///      that share token name/symbol match the hardcoded values, and that totalAssets is zero.
    function testInitialState() public {
        assertEq(address(vault.asset()), address(asset));
        assertEq(vault.name(), "MyVault4626");
        assertEq(vault.symbol(), "vMTK");
        assertEq(vault.totalAssets(), 0);
    }

    /// @dev Verifies that the first deposit into an empty vault issues shares at a 1:1 ratio.
    ///      Checks that vault holds the deposited assets, the depositor holds the shares, and
    ///      the depositor's asset balance decreases by the deposited amount.
    function testDepositMintsShares1to1() public {
        asset.approve(address(vault), 100 ether);

        uint256 shares = vault.deposit(100 ether, address(this));

        assertEq(shares, 100 ether);
        assertEq(vault.balanceOf(address(this)), 100 ether);
        assertEq(vault.totalAssets(), 100 ether);
        assertEq(asset.balanceOf(address(vault)), 100 ether);
        assertEq(asset.balanceOf(address(this)), 900 ether);
    }
}
