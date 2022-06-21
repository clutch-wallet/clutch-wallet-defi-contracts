// Copyright (C) 2022 Clutch Wallet Inc. <https://clutchwallet.xyz>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.
//
// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

import { ERC20 } from "../../interfaces/ERC20.sol";
import { SafeERC20 } from "../../shared/SafeERC20.sol";
import { TokenAmount } from "../../shared/Structs.sol";
import { InteractiveAdapter } from "../InteractiveAdapter.sol";
import { ERC20ProtocolAdapter } from "../../adapters/ERC20ProtocolAdapter.sol";
import { PoolManager } from "../../interfaces/PoolManager.sol";
import { StableMaster } from "../../interfaces/StableMaster.sol";
import { SanToken } from "../../interfaces/SanToken.sol";

/**
 * @title Interactive adapter for Angle San tokens.
 * @dev Implementation of InteractiveAdapter abstract contract.
 */
contract AngleAssetInteractiveAdapter is InteractiveAdapter, ERC20ProtocolAdapter {
    using SafeERC20 for ERC20;

    address internal constant STABLE_MASTER = 0x5adDc89785D75C86aB939E9e15bfBBb7Fc086A87;

    /**
     * @notice Deposits tokens to the StableMaster of Angle.
     * @param tokenAmounts Array with one element - TokenAmount struct with
     * underlying token address, underlying token amount to be deposited, and amount type.
     * @param data ABI-encoded additional parameters:
     *     - lpToken - sanLp token address from Angle Protocol
     * @return tokensToBeWithdrawn Array with ane element - staking token address.
     * @dev Implementation of InteractiveAdapter function.
     */
    function deposit(TokenAmount[] calldata tokenAmounts, bytes calldata data)
        external
        payable
        override
        returns (address[] memory tokensToBeWithdrawn)
    {
        require(tokenAmounts.length == 1, "ASMIA: should be 1 tokenAmount[1]");

        (address sanToken) = abi.decode(data, (address));

        address token = tokenAmounts[0].token;
        uint256 amount = getAbsoluteAmountDeposit(tokenAmounts[0]);

        tokensToBeWithdrawn = new address[](1);
        tokensToBeWithdrawn[0] = sanToken;

        ERC20(token).safeApproveMax(STABLE_MASTER, amount, "ASMIA");
        address poolManager = SanToken(sanToken).poolManager();

        // solhint-disable-next-line no-empty-blocks
        try StableMaster(STABLE_MASTER).deposit(amount, address(this), poolManager) {} catch Error(
            string memory reason
        ) {
            revert(reason);
        } catch {
            revert("ASMIA: deposit fail");
        }
    }

    /**
     * @notice Withdraws tokens from the StableMaster.
     * @param tokenAmounts Array with one element - TokenAmount struct with
     * lp token address address, lp token amount to be redeemed, and amount type.
     * @return tokensToBeWithdrawn Array with one element - underlying token.
     * @dev Implementation of InteractiveAdapter function.
     */
    function withdraw(TokenAmount[] calldata tokenAmounts, bytes calldata)
        external
        payable
        override
        returns (address[] memory tokensToBeWithdrawn)
    {
        require(tokenAmounts.length == 1, "ASMIA: should be 1 tokenAmount[2]");

        address token = tokenAmounts[0].token;
        uint256 amount = getAbsoluteAmountWithdraw(tokenAmounts[0]);

        address poolManager = SanToken(token).poolManager();

        tokensToBeWithdrawn = new address[](1);
        tokensToBeWithdrawn[0] = PoolManager(poolManager).token();

        // solhint-disable-next-line no-empty-blocks
        try
            StableMaster(STABLE_MASTER).withdraw(amount, address(this), address(this), poolManager)
        {} catch Error(string memory reason) {
            revert(reason);
        } catch {
            revert("ASMIA: withdraw fail");
        }
    }
}