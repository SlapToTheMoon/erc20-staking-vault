# ERC20 Staking Vault (Foundry)

A minimal ERC20 + staking vault system built with Foundry and OpenZeppelin.  
The goal: production-style patterns, tests, and deploy scripts, not just toy code.

## Overview

- **Token:** `MyToken` – ERC20 + Ownable with initial supply to the deployer.
- **Vault:** `StakingVault` – accepts `MyToken`, tracks user stakes, and allows stake/unstake.
- **Patterns used:**
  - `transferFrom` + `approve` ERC20 flow
  - Vault accounting (`balanceOf`, `totalStaked`, `userShareBps`)
  - Simple `nonReentrant` guard
  - Events: `Staked`, `Unstaked`
  - First steps toward ERC-4626-style helpers (`totalAssets`, `convertToShares`)

## Stack

- [Foundry](https://book.getfoundry.sh/)
- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)

## Project Structure

```text
src/
  MyToken.sol
  StakingVault.sol
test/
  MyToken.t.sol
  StakingVault.t.sol
script/
  Deploy.s.sol
foundry.toml
## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
