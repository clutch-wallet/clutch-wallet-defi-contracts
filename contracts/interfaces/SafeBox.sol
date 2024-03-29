// Copyright (C) 2022 Clutch Wallet. <https://www.clutchwallet.xyz>
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

pragma solidity 0.8.12;

/**
 * @dev SafeBOX contract interface.
 * The SafeBOX contract is available here
 * github.com/AlphaFinanceLab/homora-v2/blob/master/contracts/SafeBox.sol.
 * The SafeBoxETH contract interface is combined into this interface.
 * The SafeBoxETH contract is available here
 * github.com/AlphaFinanceLab/homora-v2/blob/master/contracts/SafeBoxETH.sol.
 */
interface SafeBox {
    function deposit(uint256) external;

    function deposit() external payable;

    function withdraw(uint256) external;

    function uToken() external view returns (address);
}
