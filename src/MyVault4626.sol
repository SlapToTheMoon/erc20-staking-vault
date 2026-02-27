// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Pattern based on OpenZeppelin's ERC4626 implementation
// Source: OpenZeppelin/openzeppelin-contracts, contracts/token/ERC20/extensions/ERC4626.sol
contract MyVault4626 is ERC4626 {
    constructor(IERC20 asset_)
        ERC20("MyVault4626", "vMTK") // name & symbol for the *share* token
        ERC4626(asset_) // underlying asset the vault wraps

    {
        // no extra logic yet
    }
}
