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

import {DecentralizedSC} from "./DecentralizedSC.sol";

/*
 * @title Decentralized Stable Coin Engine
 * @author Makar Meaculpa
 * The system is designed to be as minimal as possible, and have the tokens maintain a 1 token == 1$ peg.
 * Properties:
 *   - Exogenous Collateral (ETH, BTC)
 *   - Algorithmic Minting
 *   - Algorithmically Stable
 *
 * Similar to DAI but has no governance, no fees, and only backed by WETH and WBTC.
 * Dsc system should always be "overcollateralized". At that point, should be value of all collateral <= the $$ backed value of all the Dsc.
 */

contract DSCEngine {
    /////// Errors ////
    error DSCEngine__NeedMoreThanZero();
    error DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();

    /////// State Variables ////
    mapping(address token => address priceFeed) private s_priceFeeds;

    DecentralizedSC private immutable i_dsc;

    /////// Modifiers ////
    modifier moreThanZero(uint256 amount) {
        if (amount <= 0) {
            revert DSCEngine__NeedMoreThanZero();
        }
        _;
    }

    // modifier isAllowedToken(address token) {
    //     if(token )
    // }

    /////// Functions ////
    constructor(
        address[] memory tokenAddresses,
        address[] memory priceFeedAddresses,
        address dscAddress
    ) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }
    }

    /// External Functions ///
    function depositCollateralAndMintDsc() external {}

    /*
     * @param tokenCollateralAddress: The address of the collateral token (WETH, WBTC)
     * @param amountCollateral: The amount of collateral to deposit
     */
    function depositCollateral(
        address tokenCollateralAddress,
        uint256 amountCollateral
    ) external moreThanZero(amountCollateral) {}

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}

    function mintDsc() external {}

    function burnDsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}
}
