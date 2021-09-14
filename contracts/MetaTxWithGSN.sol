// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.4.22 <0.9.0;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

import "../node_modules/@openzeppelin/contracts/interfaces/IERC20.sol";
import "../node_modules/@opengsn/gsn/contracts/src/forwarder/IForwarder.sol";
import "../node_modules/@opengsn/contracts/src/BasePaymaster.sol";


contract MetaTxWithGSN is BasePaymaster {
    using SafeMath for uint256;
    IERC20 private token;
    address from;

    event Transfer(address indexed from, address indexed recipient, uint256 amount);
    event TransferFailed(address indexed from, address indexed recipient, uint256 amount); 

    constructor() public {
        from = _msgSender();
        // trustedForwarder = forwarder;
        // token = _token;
    }

    function transfer(address recipient, uint amount, IERC20 _token) public returns (bool sufficient) {
        // token.approve(address(this), amount);
        token = _token;
        require(amount > 0);
        if(amount > IERC20.allowance(from, address(this))) {  //check if this contract has allowance to perform this much transaction
            emit TransferFailed(from, to, amount);  
            revert();  
        } 

        token.transferFrom(from, recipient, amount);
        emit Transfer(from, recipient, amount);
        return true;
    }
  
    // allow contract to receive funds  
    function() public payable {}  
    
    // withdraw funds from this contract * @param beneficiary address to receive ether */  
    // only owner can withdraw
    // plus it makes this contract withdrawable incase funds was mistakenly sent to it
    function withdraw(address beneficiary) public payable onlyOwner whenNotPaused {  
        beneficiary.transfer(address(this).balance); //transfer all the balance to this beneficiary balance 
    }}

    function versionRecipient() external override view returns (string memory) {
        return "2.0.0";
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