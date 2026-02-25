// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IFlash {
    function triggerFlashLoan() external;
}

contract TriggerFlashLoan is Script {
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        IFlash(0xb4d5984aB1bFEe17AA0cf045F00D3F7e988c60EB).triggerFlashLoan();
        vm.stopBroadcast();
    }
}
