// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MyToken.sol";
import "../src/StakingVault.sol";

/// @title Deploy
/// @notice Foundry deployment script that provisions MyToken and StakingVault in a single broadcast.
/// @dev Execution order:
///        1. Deploy MyToken with name="MyToken", symbol="MTK", and initialSupply=1,000 MTK.
///           The broadcast signer receives the entire initial supply.
///        2. Deploy StakingVault, wiring it to the deployed MyToken as the stakeable asset.
///
///      Run with:
///        forge script script/Deploy.s.sol --broadcast --rpc-url <RPC_URL> \
///          --private-key <PRIVATE_KEY>
///
///      Contract addresses are logged to stdout after deployment for easy reference.
contract Deploy is Script {
    /// @notice Deploys MyToken and StakingVault, then logs their addresses.
    /// @dev The broadcast signer is supplied via Foundry CLI flags (--private-key, --ledger, etc.).
    ///      No environment variables are required for this script.
    function run() external {
        vm.startBroadcast();

        MyToken token = new MyToken("MyToken", "MTK", 1_000 ether);
        StakingVault vault = new StakingVault(address(token));

        vm.stopBroadcast();

        console2.log("MyToken deployed at:    ", address(token));
        console2.log("StakingVault deployed at:", address(vault));
    }
}
