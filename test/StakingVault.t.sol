// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyToken.sol";
import "../src/StakingVault.sol";

/// @title StakingVaultTest
/// @notice Unit tests for the StakingVault contract.
/// @dev The test contract starts with 1,000 MTK (from MyToken's initial supply) and acts as
///      the primary staker in all tests. Coverage includes:
///        - Initial state validation.
///        - Stake: token transfer and balance/totalStaked accounting.
///        - Unstake: token return and balance/totalStaked accounting.
///        - Multiple consecutive stakes: verifies the nonReentrant guard resets correctly.
///        - userShareBps: single-staker and zero-stake edge cases.
///        - totalAssets / convertToShares: ERC-4626-style interface compatibility.
///        - Event emissions for Staked and Unstaked.
contract StakingVaultTest is Test {
    MyToken token;
    StakingVault vault;

    /// @notice Deploys MyToken (1,000 MTK) and StakingVault before each test.
    function setUp() public {
        token = new MyToken("MyToken", "MTK", 1_000 ether);
        vault = new StakingVault(address(token));
    }

    /// @dev Verifies that the vault is wired to the correct staking token and that all balances
    ///      start at zero immediately after deployment.
    function testInitialState() public {
        assertEq(address(vault.stakingToken()), address(token));
        assertEq(vault.totalStaked(), 0);
        assertEq(vault.balanceOf(address(this)), 0);
    }

    /// @dev Verifies that staking 100 MTK transfers tokens into the vault and increments both
    ///      the caller's `balanceOf` entry and the global `totalStaked`.
    function testStakeUpdatesBalances() public {
        token.approve(address(vault), 100 ether);

        vault.stake(100 ether);

        assertEq(token.balanceOf(address(vault)), 100 ether);
        assertEq(vault.balanceOf(address(this)), 100 ether);
        assertEq(vault.totalStaked(), 100 ether);
    }

    /// @dev Verifies that unstaking reduces both the vault's held balance and the caller's staked
    ///      balance, and that the correct token amount is returned to the caller.
    ///      Scenario: stake 100, unstake 40 → vault holds 60, caller holds 940.
    function testUnstakeReducesBalancesAndReturnsTokens() public {
        token.approve(address(vault), 100 ether);
        vault.stake(100 ether);

        vault.unstake(40 ether);

        assertEq(token.balanceOf(address(vault)), 60 ether);
        assertEq(vault.balanceOf(address(this)), 60 ether);
        assertEq(vault.totalStaked(), 60 ether);
        assertEq(token.balanceOf(address(this)), 940 ether);
    }

    /// @dev Verifies that two consecutive stake calls succeed, confirming the `nonReentrant`
    ///      boolean guard resets between external calls (not permanently locked after first use).
    function testMultipleStakeCallsWork() public {
        token.approve(address(vault), 200 ether);

        vault.stake(100 ether);
        vault.stake(100 ether);

        assertEq(vault.balanceOf(address(this)), 200 ether);
        assertEq(vault.totalStaked(), 200 ether);
    }

    /// @dev Verifies that the sole staker in the vault holds 100% of the pool (10_000 bps).
    function testUserShareBpsSingleStaker() public {
        token.approve(address(vault), 100 ether);
        vault.stake(100 ether);

        assertEq(vault.userShareBps(address(this)), 10_000);
    }

    /// @dev Verifies that `userShareBps` returns 0 when the caller has no staked balance,
    ///      covering both the zero-totalStaked and zero-userStake short-circuit paths.
    function testUserShareBpsZeroWhenNoStake() public {
        assertEq(vault.userShareBps(address(this)), 0);
    }

    /// @dev Verifies that `totalAssets()` mirrors `totalStaked` exactly after a stake operation.
    function testTotalAssetsMatchesTotalStaked() public {
        token.approve(address(vault), 100 ether);
        vault.stake(100 ether);

        assertEq(vault.totalStaked(), 100 ether);
        assertEq(vault.totalAssets(), 100 ether);
    }

    /// @dev Verifies that `convertToShares` is a 1:1 identity function both before and after
    ///      tokens have been staked, since this vault has no share-price scaling.
    function testConvertToSharesIsIdentityForNow() public {
        assertEq(vault.convertToShares(123 ether), 123 ether);

        token.approve(address(vault), 100 ether);
        vault.stake(100 ether);

        assertEq(vault.convertToShares(50 ether), 50 ether);
    }

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);

    /// @dev Verifies that a successful `stake` call emits the Staked event with the correct
    ///      indexed user address and non-indexed amount.
    function testStakeEmitsEvent() public {
        token.approve(address(vault), 100 ether);

        vm.expectEmit(true, false, false, true);
        emit Staked(address(this), 100 ether);

        vault.stake(100 ether);
    }

    /// @dev Verifies that a successful `unstake` call emits the Unstaked event with the correct
    ///      indexed user address and non-indexed amount.
    function testUnstakeEmitsEvent() public {
        token.approve(address(vault), 100 ether);
        vault.stake(100 ether);

        vm.expectEmit(true, false, false, true);
        emit Unstaked(address(this), 40 ether);

        vault.unstake(40 ether);
    }
}
