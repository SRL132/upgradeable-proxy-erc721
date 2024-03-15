// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract TokenV1 is Initializable, ERC721Upgradeable {
    uint256 public store;

    function initialize(
        string calldata name,
        string calldata symbol
    ) public initializer {
        __ERC721_init(name, symbol);
        _mint(msg.sender, 1000);
        store = 0;
    }

    function version() public pure returns (string memory) {
        return "V1";
    }

    function setStore(uint256 newValue) public {
        store = newValue;
    }
}
