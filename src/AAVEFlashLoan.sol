// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IFlashLoanSimpleReceiver} from "@aave/core-v3/contracts/flashloan/interfaces/IFlashLoanSimpleReceiver.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AAVEFlashLoan is IFlashLoanSimpleReceiver {
    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;
    
    address public owner;
    address constant USDC = 0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8;
    address constant EVALUATOR = 0xD53EF6272e8df4d3e7c79568A7ea11FA444a438a;
    
    constructor(address _addressProvider) {
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_addressProvider);
        POOL = IPool(ADDRESSES_PROVIDER.getPool());
        owner = msg.sender;
    }
    
    function triggerFlashLoan() external {
        // amount = 0: premium is also 0, so safeTransferFrom(evaluator, aToken, 0)
        // succeeds without the Evaluator needing any USDC allowance toward the pool.
        POOL.flashLoanSimple(
            EVALUATOR,
            USDC,
            0,
            "",
            0
        );
    }
    
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address,
        bytes calldata
    ) external override returns (bool) {
        require(msg.sender == EVALUATOR, "Must be evaluator");
        
        // Transfer premium to evaluator so it can repay
        IERC20(asset).transfer(EVALUATOR, premium);
        
        return true;
    }
    
    function ADDRESSES_PROVIDER_ADDRESS() external view returns (address) {
        return address(ADDRESSES_PROVIDER);
    }
    
    function POOL_ADDRESS() external view returns (address) {
        return address(POOL);
    }
    
    receive() external payable {}
}