pragma ton-solidity >= 0.47.0;

pragma AbiHeader expire;
pragma AbiHeader time;

import "./Hashing.sol";

import "./Errors.sol";
import "./Fees.sol";

contract Box is Hashing {
    uint32 public static _id;   
    address _addrAuthor;

    address _creator;
    address public _recipient;
    uint128 _amount;
    uint256 _secretHash;
    uint32 _timelock;

    string _secret;

    constructor(address creator, address recipient, uint128  amount, uint256 secretHash, uint32 timelock) public{
        optional(TvmCell) oSalt = tvm.codeSalt(tvm.code());
        require(oSalt.hasValue());
        (address addrAuthor) = oSalt.get().toSlice().decode(address);
        require(addrAuthor == msg.sender, Errors.INVALID_CALLER);
        require(addrAuthor != address(0), Errors.INVALID_CALLER);

        _addrAuthor = addrAuthor;

        _creator = creator;
        _recipient = recipient;
        _amount = amount;
        _secretHash = secretHash;
        _timelock = now + timelock;
    }

    function toRecipient(bytes maybeSecret) public {
        // require (msg.sender == _recipient, Errors.INVALID_CALLER);
        require (_secretHash == secretToHash(maybeSecret), Errors.WRONG_SECRET);
    
        _recipient.transfer(_amount, false, 128);
        _secret = maybeSecret;
         
    }

    function toCreator() public {
        require(msg.sender == _creator, Errors.INVALID_CALLER);
        require(now > _timelock, Errors.TIMELOCK_IS_ACTIVE);

        msg.sender.transfer(_amount, false, 3 + 32);
    }

    function getSecret() public returns (string) {
        return _secret;
    }

    function getBoxInfo() public returns (address recipient, address creator, uint128  amount, uint256 secretHash, uint32 timelock) {
        creator = _creator;
        recipient = _recipient;
        amount = _amount;
        secretHash = _secretHash;
        timelock = _timelock;
    }
}