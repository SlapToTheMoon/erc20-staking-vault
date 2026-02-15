// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// IERC20 source: OpenZeppelin/openzeppelin-contracts v4.9.3 (token/ERC20/IERC20.sol) :contentReference[oaicite:0]{index=0}

contract StakingVault {
    IERC20 public immutable stakingToken;

    uint256 public totalStaked;
    mapping(address => uint256) public balanceOf;

    constructor(address stakingToken_) {
        // TODO: sanity-check address and set stakingToken
        require(stakingToken_ != address(0), "zero address");
        stakingToken = IERC20(stakingToken_);

    }
}
