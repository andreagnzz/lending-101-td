// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IExerciseSolution {
    function depositSomeTokens() external;
    function borrowSomeTokens() external;
    function repaySomeTokens() external;
    function withdrawSomeTokens() external;
}

contract AAVEIntegration is IExerciseSolution {
    IPool public immutable pool;
    
    address constant WBTC = 0x29f2D40B0605204364af54EC677bD022dA425d03;
    address constant USDC = 0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8; // CORRECT from reserves list
    
    constructor(address _poolAddress) {
        pool = IPool(_poolAddress);
    }
    
    function depositSomeTokens() external override {
        uint256 balance = IERC20(WBTC).balanceOf(address(this));
        require(balance > 0, "No WBTC");
        
        IERC20(WBTC).approve(address(pool), balance);
        pool.supply(WBTC, balance, address(this), 0);
    }
    
    function borrowSomeTokens() external override {
        uint256 amount = 1e6; // 1 USDC (6 decimals)
        pool.borrow(USDC, amount, 2, 0, address(this));
    }
    
    function repaySomeTokens() external override {
        uint256 balance = IERC20(USDC).balanceOf(address(this));
        
        if (balance > 0) {
            IERC20(USDC).approve(address(pool), balance);
            pool.repay(USDC, balance, 2, address(this));
        }
    }
    
    function withdrawSomeTokens() external override {
        uint256 amount = 1e6; // 0.01 WBTC
        pool.withdraw(WBTC, amount, address(this));
    }
}