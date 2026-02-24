// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MyToken.sol";
import "../src/StakingVault.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast(); // signer comes from CLI (keystore/ledger/etc.)

        MyToken token = new MyToken("MyToken", "MTK", 1_000 ether);
        StakingVault vault = new StakingVault(address(token));

        vm.stopBroadcast();

        console2.log("MyToken deployed at:", address(token));
        console2.log("StakingVault deployed at:", address(vault));
    }
}
