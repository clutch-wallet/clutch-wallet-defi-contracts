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

pragma solidity 0.6.5;
pragma experimental ABIEncoderV2;

import { ProtocolAdapter } from "../adapters/ProtocolAdapter.sol";


/**
 * @notice Mock protocol adapter for tests.
 */
contract MockAdapter is ProtocolAdapter {

    mapping(address => uint256) internal balanceOf;

    string public constant override adapterType = "Asset";

    string public constant override tokenType = "ERC20";

    constructor() public {
        balanceOf[msg.sender] = 1000;
    }

    /**
     * @return Mock balance.
     */
    function getBalance(address, address account) external view override returns (uint256) {
        return balanceOf[account];
    }
}