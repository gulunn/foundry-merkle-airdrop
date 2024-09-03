// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {BagelToken} from "../src/BagelToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployMerkleAirdrop is Script {
    uint256 CLAIM_AMOUNT = 25 ether;
    bytes32 ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;

    function run() external returns (BagelToken, MerkleAirdrop) {
        return deployMerkleAirdrop();
    }

    function deployMerkleAirdrop() public returns (BagelToken, MerkleAirdrop) {
        vm.startBroadcast();
        BagelToken bagelToken = new BagelToken();
        MerkleAirdrop merkleAirdrop = new MerkleAirdrop(bagelToken, ROOT);
        bagelToken.mint(bagelToken.owner(), CLAIM_AMOUNT * 4);
        IERC20(bagelToken).transfer(address(merkleAirdrop), CLAIM_AMOUNT * 4);
        vm.stopBroadcast();
        return (bagelToken, merkleAirdrop);
    }
}
