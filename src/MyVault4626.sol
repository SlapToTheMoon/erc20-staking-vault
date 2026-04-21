// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title MyVault4626
/// @notice ERC-4626 tokenised vault that wraps any ERC-20 asset and issues vMTK share tokens to depositors.
/// @dev A minimal, unmodified ERC-4626 implementation built on OpenZeppelin's base contract.
///      All vault mechanics — deposit, withdraw, mint, redeem, and share/asset conversions — are
///      inherited without customisation and operate with a 1:1 asset-to-share ratio until yield accrues.
///
///      Share token metadata: name = "MyVault4626", symbol = "vMTK".
///      Underlying asset: any IERC20-compatible token supplied at construction (typically MyToken/MTK).
///
///      This contract serves as a reference implementation demonstrating the ERC-4626 standard.
///      For a variant with staking rewards, see StakingVault.sol.
contract MyVault4626 is ERC4626 {
    /// @notice Deploys the vault and sets the underlying asset that depositors contribute.
    /// @dev Share token name ("MyVault4626") and symbol ("vMTK") are fixed at deployment time.
    ///      `asset_` must be a deployed, IERC20-compliant contract; passing the zero address or
    ///      a non-ERC20 address will cause downstream deposit/withdraw calls to revert.
    /// @param asset_ The ERC-20 token that this vault accepts as deposits and returns on withdrawal.
    constructor(IERC20 asset_)
        ERC20("MyVault4626", "vMTK")
        ERC4626(asset_)
    {}
}
