**Clutch DeFi Contracts**

Clutch DeFi Portfolio Management Smart Contracts is an open-source system of smart contracts allows you to track balances on diffenert protocols and execute trades with ERC20 tokens. Query user assets and debt deposited in DeFi protocols like Maker, Aave, dYdX, etc. Get the underlying components of complex derivative ERC20 tokens.

## Swap Features

* Trade (Transfer, Swap) any ERC20 token
* Two types of amounts: absolute (usual amount) and relative (percentage of balance)
* Three types of `permit()` functions for approving tokens in the same transaction (EIP2612, DAI-like, Yearn-like)
* Two types of swaps: with fixed input amount or fixed output amount
* Two types of fees:
  * **protocol fee** managed by the **Router** contract owner with possibility of one-time discounts requiring signature of an address with the special role
  * **marketplace fee** managed by the transaction creator
* Relayed transactions requiring just an EIP712 signature of the user
* Relayed transactions requiring just an EIP712 signature of the user

## Installation

Run `npm install` or `yarn` to install all the dependencies.

## Development

### Truffle Dashboard (Recommended) ###
Run `yarn truffle-dashboard` to start the Truffle Dashboard.

Run `yarn deploy:router:truffle-dashboard` to deploy the **Router** contract.
Sign deployment transaction in your browser at `http://localhost:24012/`.

Fill in address of newly deployed contract to `scripts/deployment.js`.

The same instruction applies to the **SimpleCaller** contract with `yarn deploy:sc:truffle-dashboard` command.

After filling in fee beneficiary for the chosen network in `scripts/deployment.js`, `yarn initialize:router:truffle-dashboard` command may be run.

Run `yarn verify` to verify contract on any block explorer.

### Without Truffle Dashboard ###
To deploy router on `<NETWORK_NAME>` (For example: `ropsten`), `yarn deploy:router:ropsten`

Make sure to edit `package.json` `verify:router:<NETWORK_NAME>` command. Pass deployed address to the `<CONTRACT_ADDRESS>` parameter.

To verify router on `<NETWORK_NAME>`, `yarn verify:router:<NETWORK_NAME>`

To initialize router on `<NETWORK_NAME>`, `yarn initialize:router:<NETWORK_NAME>`

When we initialize, we will set default fee percentage and default beneficiary address to receive the fee.

To deploy simple caller on `<NETWORK_NAME>` (For example: `ropsten`), `yarn deploy:sc:<NETWORK_NAME>`

Make sure to edit `package.json` `verify:sc:<NETWORK_NAME>` command. Pass deployed address to the `<CONTRACT_ADDRESS>` parameter.

To verify simple caller on `<NETWORK_NAME>`, `yarn verify:sc:<NETWORK_NAME>`

The respective `<BLOCK_EXPLORER>_API_KEY` (For example: `ETHERSCAN_API_KEY`) filled in `.env` file is required for this step.
See the `hardhat.config.ts` file for the details (`etherscan` field of `config` variable uses these API keys).

### Testing & Coverage

The **Router** contract and its dependencies is fully covered with tests.

Run `yarn test` and `yarn coverage` to run tests or coverage respectively.
`INFURA_API_KEY` filled in `.env` file is required for this step.
`REPORT_GAS` filled in `.env` file enables/disables gas reports during tests.

### Slither Tests

Run `yarn slither` to see slither test outputs.

It will not work on Windows environment, make sure you are on Linux or Mac.

### Linting

Run `yarn lint` for both JS and Solidity linters.

Run `yarn lint:eslint` and `yarn lint:solhint` to run linter for JS and Solidity separately.

### Serve Docs

`yarn docs:serve`

## Adapters

Coming Soon

### How to Add Your Adapters

Coming Soon