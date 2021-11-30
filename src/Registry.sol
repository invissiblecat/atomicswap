pragma ton-solidity >= 0.47.0;

pragma AbiHeader expire;
pragma AbiHeader time;

import "./BoxResolver.sol";

import "./Errors.sol";
import "./Fees.sol";

contract Registry is BoxResolver {

    uint32 _deployedBoxesCounter = 0;
    bool _inited = false;

    function init(
        TvmCell codeBox
    ) public 
    {
        require(!codeBox.toSlice().empty(), Errors.INVALID_ARGUMENTS);
        require(_inited == false, Errors.CONTRACT_INITED);
        tvm.accept();
        _codeBox = codeBox;
        _inited = true;
        
    }

    function deployBox (address recipient, uint128 amount, uint256 secretHash, uint32 timelock) public returns (address newBox){
        require(msg.sender != address(0), Errors.INVALID_CALLER);
        require (msg.value > Fees.DEPLOY, Errors.INVALID_VALUE);

        TvmCell state = _buildBoxState(address(this), _deployedBoxesCounter);
        newBox = new Box 
            {stateInit: state, value: Fees.DEPLOY}
            (recipient, amount, secretHash, timelock);
        
        _deployedBoxesCounter++;

    }

}

