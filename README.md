**Clutch Wallet DeFi Contract** is designed for precise DeFi portfolio accounting. To put it simply, DeFi SDK is the on-chain *balanceOf* for DeFi protocols.

## Features

#### 💥Query user assets and debt deposited in DeFi protocols like *Maker, Aave, dYdX*, etc. 
> How much debt does `0xdead..beef` have on Compound?
#### 📊Get the underlying components of complex derivative ERC20 tokens 
> How much `cUSDC` vs `ETH` does `ETHMACOAPY` have?
#### ✨Interact with multiple DeFi protocols in a unified way (coming soon)
> See [What’s next for DeFi SDK](#whats-next-for-defi-sdk-)

## Table of Contents

  - [DeFi SDK architecture](#defi-sdk-architecture)
  - [Supported protocols](#supported-protocols)
  - [How to add your adapter](#how-to-add-your-adapter)
  - [What’s next for DeFi SDK](#whats-next-for-defi-sdk-)
  - [Security vulnerabilities](#security-vulnerabilities-)

## DeFi SDK Architecture

- **ProtocolAdapter** is a special contract for every protocol. Its main purpose is to wrap all the protocol interactions.
There are different types of protocol adapters: "Asset" adapter returns the amount of the account's tokens held on the protocol and the "Debt" adapter returns the amount of the account's debt to the protocol. Some protocols do not use "simple" ERC20 tokens but instead have complex derivatives, for example the Compound protocol has CTokens. The **ProtocolAdapter** contract also provides information about the type of tokens used within it.
- **TokenAdapter** is a contract for every derivative token type (e.g cTokens, aTokens, yTokens, etc.)
Its main purpose is to provide ERC20-style token metadata as well as information about the underlying ERC20 tokens (like DAI for cDAI). Namely, it provides addresses, types and rates of underlying tokens.
- **AdapterRegistry** is a contract that a) maintains a list of *ProtocolAdapters* and *TokenAdapters* and b) is called to fetch user balances.

More detailed documentation about contracts can be found in [adapters](../../wiki/Adapters) and [AdapterRegistry](../../wiki/AdapterRegistry) documentation.

## Supported Protocols

| Protocol Name | Description | Protocol Adapters | Token Adapters |
| :-----------: | :---------: | :---------------: | :------------: |
| [Aave](./contracts/adapters/aave) | Decentralized lending & borrowing protocol. | [Asset adapter](./contracts/adapters/aave/AaveAssetAdapter.sol) <br> [Debt adapter](contracts/adapters/aave/AaveDebtAdapter.sol) | ["AToken"](./contracts/adapters/aave/AaveTokenAdapter.sol) |
| [Balancer](./contracts/adapters/balancer) | Non-custodial portfolio manager, liquidity provider, and price sensor. | [Asset adapter](./contracts/adapters/balancer/BalancerAdapter.sol) supports all Balancer pools | ["Balancer Pool Token"](./contracts/adapters/aave/BalancerTokenAdapter.sol) |
| [Bancor](./contracts/adapters/bancor) | Automated liquidity protocol. | [Asset adapter](./contracts/adapters/bancor/BancorAdapter.sol) supports Bancor pools starting from version 11 | ["SmartToken"](./contracts/adapters/aave/BancorTokenAdapter.sol) |
| [Compound](./contracts/adapters/compound) | Decentralized lending & borrowing protocol. | [Asset adapter](./contracts/adapters/compound/CompoundAssetAdapter.sol) <br> [Debt adapter](./contracts/adapters/compound/CompoundDebtAdapter.sol) | ["CToken"](./contracts/adapters/compound/CompoundTokenAdapter.sol) |
| [Curve](./contracts/adapters/curve) | Exchange liquidity pool for stablecoin trading. Supports Compound, Y, and BUSD pools. | [Asset adapter](contracts/adapters/curve/CurveAssetAdapter.sol) | ["Curve Pool Token"](contracts/adapters/curve/CurveTokenAdapter.sol) |
| [DeFi Money Market](./contracts/adapters/dmm) | Crypto through revenue-producing real world assets. | [Asset adapter](./contracts/adapters/dmm/DmmAssetAdapter.sol) | ["MToken"](contracts/adapters/dmm/DmmTokenAdapter.sol) |
| [dYdX](./contracts/adapters/dydx) | Decentralized trading platform. All 4 markets (WETH, SAI, USDC, DAI) are supported. | [Asset adapter](./contracts/adapters/dydx/DyDxAssetAdapter.sol) <br> [Debt adapter](./contracts/adapters/dydx/DyDxDebtAdapter.sol) | — |
| [Idle](./contracts/adapters/idle) | Yield aggregator for lending platforms. | [Asset adapter](./contracts/adapters/idle/IdleAdapter.sol) | ["IdleToken"](./contracts/adapters/idle/IdleTokenAdapter.sol) |
| [yearn.finance (v2/v3)](contracts/adapters/yearn) | Yield aggregator for lending platforms. Protocol adapter is duplicated for v2 and v3 versions of protocol. | [Asset adapter](contracts/adapters/yearn/YearnAdapter.sol) | ["YToken"](contracts/adapters/yearn/YearnTokenAdapter.sol) |
| [Chai](./contracts/adapters/maker) | A simple ERC20 wrapper over the Dai Savings Protocol. | [Asset adapter](./contracts/adapters/maker/ChaiAdapter.sol) | ["Chai token"](./contracts/adapters/maker/ChaiTokenAdapter.sol) |
| [Dai Savings Protocol](./contracts/adapters/maker) | Decentralized lending protocol. | [Asset adapter](./contracts/adapters/maker/DSRAdapter.sol) | — |
| [Multi-Collateral Dai](./contracts/adapters/maker) | Collateralized loans on Maker. | [Asset adapter](./contracts/adapters/maker/MCDAssetAdapter.sol) <br> [Debt adapter](./contracts/adapters/maker/MCDDebtAdapter.sol) | — |
| [PoolTogether](./contracts/adapters/poolTogether) | Decentralized no-loss lottery. Supports SAI, DAI, and USDC pools. | [Asset adapter](./contracts/adapters/poolTogether/PoolTogetherAdapter.sol) | ["PoolTogether pool"](./contracts/adapters/poolTogether/PoolTogetherTokenAdapter.sol) |
| [Synthetix](./contracts/adapters/synthetix) | Synthetic assets protocol. Asset adapter returns amount of SNX locked as collateral. | [Asset adapter](./contracts/adapters/synthetix/SynthetixAssetAdapter.sol) <br> [Debt adapter](./contracts/adapters/synthetix/SynthetixDebtAdapter.sol) | — |
| [TokenSets](./contracts/adapters/tokenSets) | TokenSets. Automated asset management strategies. | [Asset adapter](./contracts/adapters/tokenSets/TokenSetsAdapter.sol) | ["SetToken"](./contracts/adapters/tokenSets/TokenSetsTokenAdapter.sol) |
| [Uniswap V1](./contracts/adapters/uniswap) | Automated liquidity protocol. | [Asset adapter](contracts/adapters/uniswap/UniswapV1AssetAdapter.sol) supports all Uniswap pools | ["Uniswap V1 Pool Token"](./contracts/adapters/uniswap/UniswapV1TokenAdapter.sol) |
| [0x Staking](./contracts/adapters/zrx) | Liquidity rewards for staking ZRX. | [Asset adapter](./contracts/adapters/zrx/ZrxAdapter.sol) | — |

## How to Add Your Adapter

The full instructions on how to add a custom adapter to the **AdapterRegistry** contract may be found in our [wiki](../../wiki/Adding-new-adapters).

## What’s Next for DeFi SDK? 🚀

This first version of DeFi SDK is for read-only accounting purposes. Our next step is to introduce Interactive Adapters that allow users to make cross-protocol transactions from a single interface. We are incredibly excited to work with developers, users and the wider DeFi community to make these integrations as secure and accessible as possible. Watch this space, because the “De” in DeFi is about to get a whole lot more user-friendly!

## Security Vulnerabilities 🛡

If you discover a security vulnerability within DeFi SDK, please send us an e-mail at contact@clutchwallet.xyz. All security vulnerabilities will be promptly addressed.

## Dev Notes

This project uses Truffle and web3js for all Ethereum interactions and testing.

#### Set environment
Rename `.env.sample` file to `.env`, and fill in the env variables. 

`PRIVATE_KEY` and `INFURA_API_KEY` are required for `core` and `adapters` tests. 
`PRIVATE_KEY` is required for `interactiveAdapters` tests.

#### Compile contracts

`npm run compile`

#### Run tests

`npm run test:core` for `core` tests.
`npm run test:adapters` for `adapters` tests.
`npm run test:interactiveAdapters` for `interactiveAdapters` tests.

#### Run Solidity code coverage

`npm run coverage`

Currently, unsupported files are ignored.

#### Run Solidity and JS linters

`npm run lint`

Currently, unsupported files are ignored.

#### Run all the migrations scripts

`npm run deploy:network`, `network` is either `development` or `mainnet`.

## License

All smart contracts are released under GNU LGPLv3.
