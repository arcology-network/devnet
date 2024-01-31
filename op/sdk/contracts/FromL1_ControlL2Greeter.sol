//SPDX-License-Identifier: Unlicense
// This contracts runs on L1, and controls a Greeter on L2.
// The addresses are specific to Optimistic Goerli.
pragma solidity ^0.8.0;

import { ICrossDomainMessenger } from 
    "@eth-optimism/contracts/libraries/bridge/ICrossDomainMessenger.sol";
    
contract FromL1_ControlL2Greeter {
    // Taken from https://community.optimism.io/docs/useful-tools/networks/#optimism-goerli

    //address crossDomainMessengerAddr = 0x7BFE0A21796937d7E5cB1d51f433432E62aCebC0;

    //address greeterL2Addr = 0x363c9413c03901aA327d250d819237DE6b0280dd;

    function setGreeting(string calldata _greeting,address crossDomainMessengerAddr,address greeterL2Addr) public {
        bytes memory message;
            
        message = abi.encodeWithSignature("setGreeting(string,address)", 
            _greeting, msg.sender);

        ICrossDomainMessenger(crossDomainMessengerAddr).sendMessage(
            greeterL2Addr,
            message,
            1000000   // within the free gas limit amount
        );
    }      // function setGreeting 

}          // contract FromL1_ControlL2Greeter
