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

import { ERC20 } from "../../ERC20.sol";
import { ProtocolAdapter } from "../ProtocolAdapter.sol";


/**
 * @dev TokenGeyser contract interface.
 * Only the functions required for AmpleforthAdapter contract are added.
 * The TokenGeyser contract is available here
 * github.com/ampleforth/token-geyser/blob/master/contracts/TokenGeyser.sol. */
interface TokenGeyser {
    function totalStakedFor(address) external view returns (uint256);
}


/**
 * @title Asset adapter for Ampleforth.
 * @dev Implementation of ProtocolAdapter interface.
 */
contract AmpleforthAdapter is ProtocolAdapter {

    string public constant override adapterType = "Asset";

    string public constant override tokenType = "ERC20";

    address internal constant UNI_AMPL_WETH = 0xc5be99A02C6857f9Eac67BbCE58DF5572498F40c;

    address internal constant GEYSER_PILOT = 0xD36132E0c1141B26E62733e018f12Eb38A7b7678;
    address internal constant GEYSER_BEEHIVE_V1 = 0x0eEf70ab0638A763acb5178Dd3C62E49767fd940;
    address internal constant GEYSER_BEEHIVE_V2 = 0x23796Bc856ed786dCC505984fd538f91dAD3194A;
    address internal constant GEYSER_BEEHIVE_V3 = 0x075Bb66A472AB2BBB8c215629C77E8ee128CC2Fc;

    /**
     * @return AMPL balance or amount of UNI-tokens locked on the protocol by the given account.
     * @dev Implementation of ProtocolAdapter interface function.
     */
    function getBalance(address token, address account) external view override returns (uint256) {
        if (token == UNI_AMPL_WETH) {
            uint totalStaked = 0;

            totalStaked += TokenGeyser(GEYSER_PILOT).totalStakedFor(account);
            totalStaked += TokenGeyser(GEYSER_BEEHIVE_V1).totalStakedFor(account);
            totalStaked += TokenGeyser(GEYSER_BEEHIVE_V2).totalStakedFor(account);
            totalStaked += TokenGeyser(GEYSER_BEEHIVE_V3).totalStakedFor(account);

            return totalStaked;
        } else {
            return 0;
        }
    }
}