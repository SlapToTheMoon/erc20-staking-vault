// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title StakingVault
/// @notice Non-custodial ERC-20 staking vault that tracks each user's staked balance and their
///         proportional share of the total pool in basis points.
/// @dev Users stake by calling `stake`, which pulls tokens from their wallet into this contract,
///      and unstake by calling `unstake`, which returns tokens to them. No rewards are distributed
///      by this contract — it is a pure accounting layer intended to be extended with a reward
///      distribution mechanism.
///
///      Reentrancy protection is implemented via a bespoke boolean lock (`_entered`) rather than
///      OpenZeppelin's ReentrancyGuard, keeping the dependency footprint minimal.
///
///      State invariants:
///        - `totalStaked` always equals the sum of all `balanceOf` values.
///        - `totalStaked` always equals the vault's actual token balance (no yield donation path).
///        - `convertToShares` is a 1:1 identity in this implementation (no share-price mechanics).
contract StakingVault {
    /// @notice The ERC-20 token accepted for staking.
    /// @dev Immutable — the staking token cannot be changed after deployment.
    IERC20 public immutable stakingToken;

    /// @notice Aggregate amount of tokens currently staked across all users, in token-native units.
    uint256 public totalStaked;

    /// @notice Per-user staked balance, in token-native units.
    /// @dev Key: staker address. Value: amount of `stakingToken` currently held on their behalf.
    mapping(address => uint256) public balanceOf;

    /// @dev Reentrancy guard flag. Set to true for the duration of `stake` and `unstake` calls.
    bool private _entered;

    /// @notice Emitted when a user successfully stakes tokens.
    /// @param user   Address that initiated the stake.
    /// @param amount Quantity of tokens staked, in token-native units.
    event Staked(address indexed user, uint256 amount);

    /// @notice Emitted when a user successfully unstakes tokens.
    /// @param user   Address that initiated the unstake.
    /// @param amount Quantity of tokens returned to the user, in token-native units.
    event Unstaked(address indexed user, uint256 amount);

    /// @dev Prevents reentrant calls to `stake` and `unstake` by blocking re-entry while a call
    ///      is in progress. The flag is reset after the function body executes.
    modifier nonReentrant() {
        require(!_entered, "ReentrancyGuard: revert");
        _entered = true;
        _;
        _entered = false;
    }

    /// @notice Deploys the staking vault and sets the token that users will stake.
    /// @dev Reverts if `stakingToken_` is the zero address to prevent misconfiguration at deploy time.
    /// @param stakingToken_ Address of the ERC-20 token to accept for staking. Must not be zero.
    constructor(address stakingToken_) {
        require(stakingToken_ != address(0), "zero address");
        stakingToken = IERC20(stakingToken_);
    }

    /// @notice Stakes `amount` tokens on behalf of the caller.
    /// @dev Pulls `amount` tokens from `msg.sender` into this contract via `transferFrom`.
    ///      The caller must have approved this contract for at least `amount` tokens beforehand.
    ///      Updates both `balanceOf[msg.sender]` and `totalStaked`, then emits {Staked}.
    ///      Protected by `nonReentrant`. Reverts if `amount` is zero.
    /// @param amount Quantity of `stakingToken` to stake, in token-native units. Must be > 0.
    function stake(uint256 amount) external nonReentrant {
        require(amount > 0, "zero amount");

        stakingToken.transferFrom(msg.sender, address(this), amount);
        balanceOf[msg.sender] += amount;
        totalStaked += amount;

        emit Staked(msg.sender, amount);
    }

    /// @notice Withdraws `amount` previously staked tokens back to the caller.
    /// @dev Decrements `balanceOf[msg.sender]` and `totalStaked`, then transfers tokens out.
    ///      Balance is decremented before the transfer (checks-effects-interactions pattern),
    ///      which together with `nonReentrant` prevents reentrancy attacks.
    ///      Reverts if `amount` is zero or if the caller's staked balance is insufficient.
    ///      Emits {Unstaked} on success.
    /// @param amount Quantity of `stakingToken` to withdraw, in token-native units. Must be > 0
    ///               and <= `balanceOf[msg.sender]`.
    function unstake(uint256 amount) external nonReentrant {
        require(amount > 0, "zero amount");
        require(balanceOf[msg.sender] >= amount);

        balanceOf[msg.sender] -= amount;
        totalStaked -= amount;
        stakingToken.transfer(msg.sender, amount);

        emit Unstaked(msg.sender, amount);
    }

    /// @notice Returns a `user`'s proportional share of the total staked pool in basis points (bps).
    /// @dev Basis points: 10_000 bps = 100%. Computed as `balanceOf[user] * 10_000 / totalStaked`.
    ///      Returns 0 if `totalStaked` is zero or the user has no staked balance, avoiding
    ///      division-by-zero and unnecessary computation.
    /// @param user Address to query.
    /// @return Proportional share in basis points (0–10_000 inclusive).
    function userShareBps(address user) public view returns (uint256) {
        if (totalStaked == 0) return 0;

        uint256 userStake = balanceOf[user];
        if (userStake == 0) return 0;

        return userStake * 10_000 / totalStaked;
    }

    /// @notice Returns the total amount of `stakingToken` held in the vault.
    /// @dev Equivalent to `totalStaked` in this implementation. Provided for ERC-4626-style
    ///      interface compatibility; does not query the token contract's balance directly.
    /// @return Total staked token amount in token-native units.
    function totalAssets() public view returns (uint256) {
        return totalStaked;
    }

    /// @notice Converts an asset amount to an equivalent share amount.
    /// @dev This vault uses a 1:1 conversion with no share-price mechanism, so the function
    ///      is an identity: shares == assets. Provided for ERC-4626-style interface compatibility.
    /// @param assets Asset amount to convert, in token-native units.
    /// @return shares Equivalent share amount (identical to `assets` in this implementation).
    function convertToShares(uint256 assets) public view returns (uint256 shares) {
        return assets;
    }
}
