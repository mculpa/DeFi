// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedSC} from "../../src/DecentralizedSC.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";

contract Handler is Test {
    DSCEngine dsce;
    DecentralizedSC dsc;
    ERC20Mock weth;
    ERC20Mock wbtc;
    uint256 MAX_DEPOSIT_SIZE = type(uint96).max;
    uint256 public timesMintIsCalled;
    address[] public usersWithCollateralDeposited;

    constructor(DSCEngine _dsce, DecentralizedSC _dsc) {
        dsce = _dsce;
        dsc = _dsc;
        address[] memory collateralTokens = dsce.getCollateralTokens();
        weth = ERC20Mock(collateralTokens[0]);
        wbtc = ERC20Mock(collateralTokens[1]);
    }

    function depositCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);
        amountCollateral = bound(amountCollateral, 1, MAX_DEPOSIT_SIZE);

        vm.startPrank(msg.sender);
        collateral.mint(msg.sender, amountCollateral);
        collateral.approve(address(dsce), amountCollateral);

        dsce.depositCollateral(address(collateral), amountCollateral);
        //dsce.depositCollateral(collateral, amountCollateral);
        vm.stopPrank();
        usersWithCollateralDeposited.push(msg.sender);
    }

    function redeemCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);
        uint256 maxCollateralToRedeem = dsce.getCollateralBalanceOfUser(address(collateral), msg.sender);
        amountCollateral = bound(amountCollateral, 0, maxCollateralToRedeem);
        if (amountCollateral == 0) {
            return;
        }
        dsce.redeemCollateral(address(collateral), amountCollateral);
    }

    function mintDsc(uint256 amount, uint256 addressSeed) public {
        if (usersWithCollateralDeposited.length == 0) {
            return;
        }
        //amount = bound(amount, 1, MAX_DEPOSIT_SIZE);
        address sender = usersWithCollateralDeposited[addressSeed % usersWithCollateralDeposited.length];
        vm.startPrank(sender);
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = dsce.getAccountInformation(sender);
        int256 maxDscToMint = ((int256(collateralValueInUsd) / 2)) - int256(totalDscMinted);
        console.log("maxDscToMint: ", maxDscToMint);
        if (maxDscToMint < 0) {
            return;
        }
        amount = bound(amount, 0, uint256(maxDscToMint));
        if (amount == 0) {
            return;
        }

        dsce.mintDsc(amount);
        vm.stopPrank();
    }

    function _getCollateralFromSeed(uint256 collateralSeed) internal view returns (ERC20Mock) {
        if (collateralSeed % 2 == 0) {
            return weth;
        } else {
            return wbtc;
        }
    }
}
