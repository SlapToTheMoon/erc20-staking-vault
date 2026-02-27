// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyToken.sol";
import "../src/MyVault4626.sol";

contract MyVault4626Test is Test {
    MyToken asset;
    MyVault4626 vault;

    function setUp() public {
        asset = new MyToken("MyToken", "MTK", 1_000 ether);
        vault = new MyVault4626(asset);
    }

    function testInitialState() public {
        // ERC4626 exposes the underlying asset via asset()
        assertEq(address(vault.asset()), address(asset));
        assertEq(vault.name(), "MyVault4626");
        assertEq(vault.symbol(), "vMTK");
        assertEq(vault.totalAssets(), 0);
    }

    function testDepositMintsShares1to1() public {
        // this test contract owns the initial 1_000 ether of asset
        asset.approve(address(vault), 100 ether);

        uint256 shares = vault.deposit(100 ether, address(this));

        assertEq(shares, 100 ether); // 1:1 in our simple setup
        assertEq(vault.balanceOf(address(this)), 100 ether); // share balance
        assertEq(vault.totalAssets(), 100 ether); // underlying tracked
        assertEq(asset.balanceOf(address(vault)), 100 ether);
        assertEq(asset.balanceOf(address(this)), 900 ether);
    }
}
