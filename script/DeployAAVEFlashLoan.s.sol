// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/AAVEFlashLoan.sol";

contract DeployAAVEFlashLoan is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address addressesProvider = 0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A; // Sepolia
        
        vm.startBroadcast(deployerPrivateKey);
        
        AAVEFlashLoan flashLoan = new AAVEFlashLoan(addressesProvider);
        
        vm.stopBroadcast();
        
        console.log("AAVEFlashLoan deployed at:", address(flashLoan));
    }
}