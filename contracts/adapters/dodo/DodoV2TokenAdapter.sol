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
import { TokenMetadata, Component } from "../../Structs.sol";
import { TokenAdapter } from "../TokenAdapter.sol";


/**
 * @dev DVM contract interface.
 * Only the functions required for DodoV2TokenAdapter contract are added.
 * The DVM contract is available here
 * github.com/DODOEX/contractV2/blob/main/contracts/DODOVendingMachine/impl/DVM.sol. */
interface DVM {
    // solhint-disable func-name-mixedcase
    function _BASE_TOKEN_() external view returns (address);
    function _QUOTE_TOKEN_() external view returns (address);
    // solhint-enable func-name-mixedcase
}


/**
 * @title Token adapter for DODO V2 pool tokens.
 * @dev Implementation of TokenAdapter interface.
 */
contract DodoV2TokenAdapter is TokenAdapter {

    /**
     * @return TokenMetadata struct with ERC20-style token info.
     * @dev Implementation of TokenAdapter interface function.
     */
    function getMetadata(address token) external view override returns (TokenMetadata memory) {
        return TokenMetadata({
            token: token,
            name: getPoolName(token),
            symbol: ERC20(token).symbol(),
            decimals: ERC20(token).decimals()
        });
    }

    /**
     * @return Array of Component structs with underlying tokens rates for the given token.
     * @dev Implementation of TokenAdapter interface function.
     */
    function getComponents(address token) external view override returns (Component[] memory) {
        address baseToken = DVM(token)._BASE_TOKEN_();
        address quoteToken = DVM(token)._QUOTE_TOKEN_();
        uint256 totalSupply = ERC20(token).totalSupply();

        Component[] memory underlyingTokens = new Component[](2);

        underlyingTokens[0] = Component({
            token: baseToken,
            tokenType: "ERC20",
            rate: totalSupply == 0 ? 0 : ERC20(baseToken).balanceOf(token) * 1e18 / totalSupply
        });

        underlyingTokens[1] = Component({
            token: quoteToken,
            tokenType: "ERC20",
            rate: totalSupply == 0 ? 0 : ERC20(quoteToken).balanceOf(token) * 1e18 / totalSupply
        });

        return underlyingTokens;
    }

    function getPoolName(address token) internal view returns (string memory) {
        return string(
            abi.encodePacked(
                "DODO ",
                getSymbol(DVM(token)._BASE_TOKEN_()),
                "/",
                getSymbol(DVM(token)._QUOTE_TOKEN_()),
                " Pool"
            )
        );
    }

    function getSymbol(address token) internal view returns (string memory) {
        (, bytes memory returnData) = token.staticcall(
            abi.encodeWithSelector(ERC20(token).symbol.selector)
        );

        if (returnData.length == 32) {
            return convertToString(abi.decode(returnData, (bytes32)));
        } else {
            return abi.decode(returnData, (string));
        }
    }

    /**
     * @dev Internal function to convert bytes32 to string and trim zeroes.
     */
    function convertToString(bytes32 data) internal pure returns (string memory) {
        uint256 counter = 0;
        bytes memory result;

        for (uint256 i = 0; i < 32; i++) {
            if (data[i] != bytes1(0)) {
                counter++;
            }
        }

        result = new bytes(counter);
        counter = 0;
        for (uint256 i = 0; i < 32; i++) {
            if (data[i] != bytes1(0)) {
                result[counter] = data[i];
                counter++;
            }
        }

        return string(result);
    }
}
