// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// Pattern based on OpenZeppelin ERC20 + Ownable
// Source: OpenZeppelin/openzeppelin-contracts @ fd81a96f01cc42ef1c9a5399364968d0e07e9e90
contract MyToken is ERC20, Ownable {
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply
    )
        ERC20(name_, symbol_)
        Ownable(msg.sender) // ← pass deployer as initial owner
    {
        _mint(msg.sender, initialSupply);
    }
}
