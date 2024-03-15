// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {TokenV1} from "../../../src/TokenV1.sol";
import {TokenV2} from "../../../src/TokenV2.sol";
import {TokenFactory} from "../../../src/TokenFactory.sol";
import {Test, console} from "forge-std/Test.sol";

contract ClonesTest is Test {
    address public OWNER = makeAddr("owner");
    string constant tokenName = "TestToken";
    string constant tokenSymbol = "TEST";
    function testCreateTokenV1() public {
        vm.startPrank(OWNER);
        TokenV1 token = new TokenV1();
        TokenFactory factory = new TokenFactory(address(token), OWNER);
        factory.createToken(tokenName, tokenSymbol);
        vm.stopPrank();
    }
    function testCreateAndUpgradeToV2() public {
        vm.startPrank(OWNER);
        TokenV1 token = new TokenV1();
        TokenFactory factory = new TokenFactory(address(token), OWNER);
        TokenV2 token2 = new TokenV2();
        factory.createToken(tokenName, tokenSymbol);
        address updatedTokenAddress = factory.createToken(
            tokenName,
            tokenSymbol
        );
        factory.upgradeImplementation(address(token2));
        assertEq(TokenV2(updatedTokenAddress).version(), "V2");
        vm.stopPrank();
    }

    function testPreservesStateWhenUpgrading(uint256 x) public {
        vm.startPrank(OWNER);
        TokenV1 token = new TokenV1();
        TokenFactory factory = new TokenFactory(address(token), OWNER);
        TokenV2 token2 = new TokenV2();
        address updatedTokenAddress = factory.createToken(
            tokenName,
            tokenSymbol
        );
        TokenV1(updatedTokenAddress).setStore(x);
        assertEq(TokenV1(updatedTokenAddress).store(), x);
        factory.upgradeImplementation(address(token2));
        assertEq(TokenV2(updatedTokenAddress).store(), x);
        assertEq(TokenV2(updatedTokenAddress).version(), "V2");
        vm.stopPrank();
    }

    function testEachClonePreservesStateWhenUpgrading(
        uint256 x,
        uint256 y
    ) public {
        vm.startPrank(OWNER);
        TokenV1 token = new TokenV1();
        TokenFactory factory = new TokenFactory(address(token), OWNER);
        TokenV2 token2 = new TokenV2();
        address updatedTokenAddress = factory.createToken(
            tokenName,
            tokenSymbol
        );
        TokenV1(updatedTokenAddress).setStore(x);
        assertEq(TokenV1(updatedTokenAddress).store(), x);
        address updatedTokenAddress2 = factory.createToken(
            tokenName,
            tokenSymbol
        );
        TokenV1(updatedTokenAddress2).setStore(y);
        assertEq(TokenV1(updatedTokenAddress2).store(), y);
        factory.upgradeImplementation(address(token2));
        assertEq(TokenV2(updatedTokenAddress).store(), x);
        assertEq(TokenV2(updatedTokenAddress2).store(), y);
        assertEq(TokenV2(updatedTokenAddress).version(), "V2");
        assertEq(TokenV2(updatedTokenAddress2).version(), "V2");
        vm.stopPrank();
    }
}
