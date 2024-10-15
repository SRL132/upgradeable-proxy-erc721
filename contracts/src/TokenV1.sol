// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract TokenV1 is Initializable, ERC721Upgradeable {
    uint256 public s_store;

    function initialize(
        string calldata _name,
        string calldata _symbol
    ) public initializer {
        __ERC721_init(_name, _symbol);
        _mint(msg.sender, 1000);
        s_store = 0;
    }

    function version() public pure returns (string memory) {
        return "V1";
    }

    function setStore(uint256 _newValue) public {
        s_store = _newValue;
    }
}
