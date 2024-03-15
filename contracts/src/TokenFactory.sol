// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {TokenV1} from "./TokenV1.sol";

contract TokenFactory is Ownable {
    UpgradeableBeacon immutable beacon;
    event TokenCreated(address indexed cloneAddress);

    constructor(
        address implementationAddress,
        address initialOwner
    ) Ownable(initialOwner) {
        beacon = new UpgradeableBeacon(implementationAddress, address(this));
        //  transferOwnership(msg.sender);
    }

    function upgradeImplementation(address newImplementation) public onlyOwner {
        beacon.upgradeTo(newImplementation);
    }

    function createToken(
        string calldata name,
        string calldata symbol
    ) external returns (address) {
        BeaconProxy token = new BeaconProxy(
            address(beacon),
            abi.encodeWithSelector(
                TokenV1(address(0)).initialize.selector,
                name,
                symbol
            )
        );

        emit TokenCreated(address(token));
        return address(token);
    }

    function getBeaconOwner() public view returns (address) {
        return beacon.owner();
    }
}
