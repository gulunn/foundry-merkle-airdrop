// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {BagelToken} from "../src/BagelToken.sol";
import {DeployMerkleAirdrop} from "../script/DeployMerkleAirdrop.s.sol";

contract MerkleAirdropTest is Test {
    DeployMerkleAirdrop deployer;
    MerkleAirdrop merkleAirdrop;
    BagelToken bagelToken;

    bytes32 ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 AMOUNT = 25 ether;
    bytes32 proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] proof = [proofOne, proofTwo];

    address user;
    uint256 userPrivateKey;

    function setUp() public {
        // Deploy token and airdrop contracts and mint some tokens to the airdrop contract
        deployer = new DeployMerkleAirdrop();
        (bagelToken, merkleAirdrop) = deployer.run();
        (user, userPrivateKey) = makeAddrAndKey("user");
    }

    function testUserCanClaim() public {
        uint256 userStartingBalance = bagelToken.balanceOf(user);
        vm.startPrank(user);
        merkleAirdrop.claim(user, AMOUNT, proof);
        vm.stopPrank();
        uint256 userEndingBalance = bagelToken.balanceOf(user);
        console.log("Ending balance: ", userEndingBalance);
        assertEq(userEndingBalance, userStartingBalance + AMOUNT);
    }
}
