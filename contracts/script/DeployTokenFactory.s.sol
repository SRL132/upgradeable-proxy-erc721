// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {TokenFactory} from "../src/TokenFactory.sol";

contract DeployTokenFactory is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;
    address public ownerAddress = vm.envAddress("OWNER_ADDRESS");
    address public tokenV1Address = 0x29A07C9880DF4379454dac446599d5554E5C4489;
    function run() external returns (TokenFactory) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }

        vm.startBroadcast(deployerKey);
        TokenFactory tokenFactory = new TokenFactory(
            tokenV1Address,
            ownerAddress
        );
        vm.stopBroadcast();
        return tokenFactory;
    }
}
