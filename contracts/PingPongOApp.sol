// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { OApp, Origin, MessagingFee } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OApp.sol";
import { OptionsBuilder } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol";

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract PingPongOApp is OApp {
    string public constant PING_MESSAGE = "ping";

    event SendPing(uint32 dstEid);
    event Ping(string message);
    event LZReceiveGasUpdate(uint256 gas);

    error InvalidMessage();

    uint128 public _lzReceiveGas = 400_000;

    constructor(address _endpoint, address _owner) OApp(_endpoint, _owner) Ownable(_owner) { }

    function setReceiveGas(uint128 _gas) external onlyOwner {
        _lzReceiveGas = _gas;
        emit LZReceiveGasUpdate(_gas);
    }

    // Sends a message from the source to destination chain.
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

    function _lzReceive(
        Origin calldata _origin, // struct containing info about the message sender
        bytes32 _guid, // global packet identifier
        bytes calldata _payload, // encoded message payload being received
        address _executor, // the Executor address.
        bytes calldata _extraData// arbitrary data appended by the Executor
    )
        internal
        override
    {
        bytes32 messageDigest = abi.decode(payload, (bytes32));
        if (messageDigest == keccak256(abi.encodePacked(PING_MESSAGE))) {
            emit Ping(PING_MESSAGE);
        } else {
            super._lzReceive(_origin, _guid, _payload, _executor, _extraData);
        }
    }
}
