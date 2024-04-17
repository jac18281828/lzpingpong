// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { OApp, Origin, MessagingFee } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OApp.sol";
import { OptionsBuilder } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol";

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title PingPongOApp
 * @dev This contract demonstrates how to create an OApp that sends a message to another chain.
 */
contract PingPongOApp is OApp {
    string public constant PING_MESSAGE = "ping";

    event SendPing(uint32 dstEid);
    event Ping(string message);
    event LZReceiveGasUpdate(uint256 gas);

    error InvalidMessage();

    uint128 public _lzReceiveGas = 400_000;

    constructor(address _endpoint, address _owner) OApp(_endpoint, _owner) Ownable(_owner) { }

    /**
     * @dev Set the gas to be used when receiving messages on destination chain
     * @param _gas the gas to be used
     */
    function setReceiveGas(uint128 _gas) external onlyOwner {
        _lzReceiveGas = _gas;
        emit LZReceiveGasUpdate(_gas);
    }

    /**
     * send a ping from the current chain to the destination chain
     * @param _dstEid the destination chain's endpoint ID
     */
    function sendPing(uint32 _dstEid) external payable {
        bytes memory options = OptionsBuilder.newOptions();
        options = OptionsBuilder.addExecutorLzReceiveOption(options, _lzReceiveGas, 0);
        bytes32 pingDigest = keccak256(abi.encodePacked(PING_MESSAGE)); // Generates a unique identifier for the
        // message.
        bytes memory payload = abi.encode(pingDigest); // Encodes message as bytes.
        _lzSend(
            _dstEid, // Destination chain's endpoint ID.
            payload, // Encoded message payload being sent.
            options, // Message execution options (e.g., gas to use on destination).
            MessagingFee(msg.value, 0), // Fee struct containing native gas and ZRO token.
            payable(msg.sender) // The refund address in case the send call reverts.
        );
        emit SendPing(_dstEid);
    }

    /**
     * @dev This function is called by the LayerZero protocol when a message is received.
     * @param _payload encoded message payload being received.
     */
    function _lzReceive(
        Origin calldata, // struct containing info about the message sender
        bytes32, // global packet identifier
        bytes calldata _payload, // encoded message payload being received
        address, // the Executor address.
        bytes calldata // arbitrary data appended by the Executor
    )
        internal
        override
    {
        bytes32 messageDigest = abi.decode(_payload, (bytes32));
        if (messageDigest == keccak256(abi.encodePacked(PING_MESSAGE))) {
            emit Ping(PING_MESSAGE);
        } else {
            revert InvalidMessage();
        }
    }
}
