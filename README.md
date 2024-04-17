# PingPongOAPP

## LayerZero PingPong OApp Demo

This is a demonstration of a LayerZero OApp (Overlay Application) that performs "ping" operations between two different blockchains, specifically Sepolia and Holesky testnets work.   

## Overview

The PingPong OApp sends a "ping" transaction from one blockchain (Sepolia) to another (Holesky). The receiving blockchain (Holesky). This demonstrates the interoperability capabilities of LayerZero.

## Prerequisites

- LayerZero SDK
- OpenZeppelin
- Sepolia and Holesky blockchain nodes running


# Deployments

| Contract     | Address                                    | Network |
| ------------ | ------------------------------------------ | ------- |
| PingPongOApp | 0xDC685bf4b416f8D5cAc64927E9c516be45b81d28 | Sepolia |
| PingPongOApp | 0xD99E8bA5259Dd2b8B9aBFE0eD78913ec60B8F898 | Holesky |

## Setup

Clone the repository and install dependencies:

```shell
$ git clone https://github.com/jac18281828/lzpingpong.git
$ cd lzpingpong
$ npm ci --frozen-lockfile
$ forge install
$ forge fmt --check
$ npm run lint


## About Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

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
