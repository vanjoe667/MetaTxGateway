// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity >=0.4.22 <0.9.0;

import "./ERC20.sol";
import "@openzeppelin/contracts/GSN/GSNRecipient.sol";



contract MetaTxWithGSN is GSNRecipient {
    ERC20 private token;

    constructor(ERC20 _token) pulic {
        token = _token;
    }

    function transfer(address recipient, uint256 amount) external{
        token.approve(address(this), amount);
        token.transferFrom(msgSender(), recipient, amount);
    }

    function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    ) external view returns (uint256, bytes memory);

    function preRelayedCall(
        GSNTypes.RelayRequest relayRequest,
        bytes approvalData,
        uint256 maxPossibleGas
    )
    external
    returns (
        bytes memory context,
        bool rejectOnRecipientRevert
    );

    function postRelayedCall(
        bytes context,
        bool success,
        bytes32 preRetVal,
        uint256 gasUseWithoutPost,
        GSNTypes.GasData calldata gasData
    ) external;

}