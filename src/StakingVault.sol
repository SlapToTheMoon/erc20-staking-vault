// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// IERC20 source: OpenZeppelin/openzeppelin-contracts v4.9.3 (token/ERC20/IERC20.sol) :contentReference[oaicite:0]{index=0}

contract StakingVault {
    IERC20 public immutable stakingToken;

    uint256 public totalStaked;
    mapping(address => uint256) public balanceOf;

    bool private _entered;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);


    modifier nonReentrant() {
       require(!_entered, "ReentrancyGuard: revert");
       _entered = true;
        _;
        _entered = false;
    }

    constructor(address stakingToken_) {
        // TODO: sanity-check address and set stakingToken
        require(stakingToken_ != address(0), "zero address");
        stakingToken = IERC20(stakingToken_);

    }
    function stake(uint256 amount) external nonReentrant {
    require(amount > 0, "zero amount");

    // 1) pull tokens from user into the vault
    stakingToken.transferFrom(msg.sender, address(this), amount);
    // 2) update balanceOf[msg.sender]
balanceOf[msg.sender] += amount;
    // 3) update totalStaked
    totalStaked += amount;

    emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external nonReentrant {
    require(amount > 0, "zero amount");

    // 1) check user has enough staked
    require(balanceOf[msg.sender] >= amount);
    // 2) update balanceOf[msg.sender]
    balanceOf[msg.sender] -= amount;
    // 3) update totalStaked
    totalStaked -= amount;
    // 4) transfer tokens from vault back to user
    stakingToken.transfer(msg.sender, amount);

    emit Unstaked(msg.sender, amount);
}


function userShareBps(address user) public view returns (uint256) {
    if (totalStaked == 0) return 0;

    uint256 userStake = balanceOf[user];
    if (userStake == 0) return 0;

    return userStake * 10_000 / totalStaked;
}

function totalAssets() public view returns (uint256) {
    return totalStaked;
}

function convertToShares(uint256 assets) public view returns (uint256 shares) {
    return assets;
}

}
