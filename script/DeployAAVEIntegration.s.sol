// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/AAVEIntegration.sol";

contract DeployAAVEIntegration is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address poolAddress = 0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951; // Sepolia AAVE Pool
        
        vm.startBroadcast(deployerPrivateKey);
        
        AAVEIntegration aaveIntegration = new AAVEIntegration(poolAddress);
        
        vm.stopBroadcast();
        
        console.log("AAVEIntegration deployed at:", address(aaveIntegration));
    }
}