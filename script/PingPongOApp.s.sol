// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { Script, console } from "forge-std/Script.sol";

import { PingPongOApp } from "../contracts/PingPongOApp.sol";

contract PingPongOAppScript is Script {
    event DeployOApp(address oAppAddress);

    function deploy() public {
        vm.startBroadcast();
        address endPoint = vm.envAddress("LZ_ENDPOINT");
        address owner = vm.envAddress("OWNER");
        PingPongOApp pingPong = new PingPongOApp(endPoint, owner);
        emit DeployOApp(address(pingPong));
        // solhint-disable-next-line no-console
        console.log("PingPongOApp deployed at: ", address(pingPong));
        vm.stopBroadcast();
    }
}
