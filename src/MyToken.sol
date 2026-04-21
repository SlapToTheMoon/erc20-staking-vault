// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title MyToken
/// @notice A general-purpose ERC-20 token with configurable name, symbol, and initial supply,
///         owned by the deployer via OpenZeppelin's Ownable pattern.
/// @dev Extends OpenZeppelin ERC20 and Ownable. The full `initialSupply` is minted to the deployer
///      at construction; no further minting mechanism is exposed by this contract.
///
///      Intended use: acts as the stakeable asset for StakingVault and the underlying asset for
///      MyVault4626 in the erc20-staking-vault project. In tests it is instantiated with
///      name="MyToken", symbol="MTK", and initialSupply=1_000 ether.
contract MyToken is ERC20, Ownable {
    /// @notice Deploys the token, mints `initialSupply` to the deployer, and sets the deployer as owner.
    /// @dev The deployer address (msg.sender at construction time) receives both the initial token
    ///      balance and the Ownable ownership role. No additional roles or minting authority exist.
    /// @param name_          Human-readable name of the token (e.g. "MyToken").
    /// @param symbol_        Ticker symbol of the token (e.g. "MTK").
    /// @param initialSupply  Total token supply to mint, in wei (18-decimal units).
    constructor(string memory name_, string memory symbol_, uint256 initialSupply)
        ERC20(name_, symbol_)
        Ownable(msg.sender)
    {
        _mint(msg.sender, initialSupply);
    }
}
