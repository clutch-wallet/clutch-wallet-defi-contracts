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
 * @dev BasePool contract interface.
 * Only the functions required for PoolTogether contracts are added.
 * The BasePool contract is available here
 * github.com/pooltogether/pooltogether-contracts/blob/master/contracts/BasePool.sol.
 */
interface BasePool {
    function totalBalanceOf(address) external view returns (uint256);

    function token() external view returns (address);
}
