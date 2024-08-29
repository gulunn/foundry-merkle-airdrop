// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    using SafeERC20 for IERC20;

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();

    IERC20 private immutable i_airdropToken;
    bytes32 private immutable i_merkleRoot;

    mapping(address => bool) private s_hasClaimed;

    event TokenClaimed(address indexed account, uint256 amount);

    /////////////////////////////////////////////////////////////
    //                        FUNCTIONS                        //
    /////////////////////////////////////////////////////////////

    constructor(IERC20 airdropToken, bytes32 merkleRoot) {
        i_airdropToken = airdropToken;
        i_merkleRoot = merkleRoot;
    }

    function claim(address account, uint256 amount, bytes32[] calldata proof) external {
        // Check if the account has already claimed
        if (s_hasClaimed[account]) revert MerkleAirdrop__AlreadyClaimed();

        // Verify the merkle proof
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        if (!MerkleProof.verify(proof, i_merkleRoot, leaf)) revert MerkleAirdrop__InvalidProof();

        // Mark the account as claimed and transfer the tokens
        s_hasClaimed[account] = true;
        emit TokenClaimed(account, amount);
        i_airdropToken.safeTransfer(account, amount);
    }

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropToken() external view returns (IERC20) {
        return i_airdropToken;
    }
}
