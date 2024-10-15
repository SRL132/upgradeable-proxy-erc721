// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract TokenV2 is Initializable, ERC721Upgradeable {
    uint256 public s_store;

    function version() public pure returns (string memory) {
        return "V2";
    }

    function setStore(uint256 newValue) public {
        s_store = newValue;
    }
}
