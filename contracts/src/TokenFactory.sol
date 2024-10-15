// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {TokenV1} from "./TokenV1.sol";

contract TokenFactory is Ownable {
    UpgradeableBeacon immutable i_beacon;

    event TokenCreated(address indexed cloneAddress);

    constructor(
        address _implementationAddress,
        address _initialOwner
    ) Ownable(_initialOwner) {
        i_beacon = new UpgradeableBeacon(_implementationAddress, address(this));
    }

    function upgradeImplementation(
        address _newImplementation
    ) public onlyOwner {
        i_beacon.upgradeTo(_newImplementation);
    }

    function createToken(
        string calldata _name,
        string calldata _symbol
    ) external returns (address) {
        BeaconProxy token = new BeaconProxy(
            address(i_beacon),
            abi.encodeWithSelector(
                TokenV1(address(0)).initialize.selector,
                _name,
                _symbol
            )
        );

        emit TokenCreated(address(token));
        return address(token);
    }

    function getBeaconOwner() public view returns (address) {
        return i_beacon.owner();
    }
}
