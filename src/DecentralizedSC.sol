// SPDX-License-Identifier: MIT

// This is considered an Exogenous, Decentralized, Anchored (pegged), Crypto Collateralized low volitility coin

// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

pragma solidity ^0.8.18;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/*
 * @title Decentralized Stable Coin
 * @author Makar Meaculpa
 * Collateral: Exogenous (ETH & BTC)
 * Minting: Algorithmic
 * Relative Stability: Pegged to USD
 *
 *
 */
contract DecentralizedSC is ERC20Burnable, Ownable {
    error DecentralizedSC__MustBeMoreThatZero();
    error DecentralizedSC__BurnAmountExceedsBalance();
    error DecentralizedSC__NotZeroAddress();

    constructor() ERC20("Decentralized Stable Coin", "DSC") {}

    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) {
            revert DecentralizedSC__MustBeMoreThatZero();
        }
        if (balance < _amount) {
            revert DecentralizedSC__BurnAmountExceedsBalance();
        }
        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
        if (_to == address(0)) {
            revert DecentralizedSC__NotZeroAddress();
        }
        if (_amount <= 0) {
            revert DecentralizedSC__MustBeMoreThatZero();
        }
        _mint(_to, _amount);
        return true;
    }
}
