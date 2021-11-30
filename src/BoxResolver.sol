pragma ton-solidity >= 0.47.0;

import './Box.sol';

contract BoxResolver {
    TvmCell _codeBox;

    function resolveBox(address addrAuthor, uint32 id) public view returns (address addrBox) {
        TvmCell state = _buildBoxState(addrAuthor, id);
        uint256 hashState = tvm.hash(state);
        addrBox = address.makeAddrStd(0, hashState);
    }

    function resolveBoxCodeHash(address addrAuthor) external view returns (uint256 codeHashBox) {
        TvmCell code = _buildBoxCode(addrAuthor);
        codeHashBox = tvm.hash(code);
    }

    function _buildBoxState(address addrAuthor, uint32 id) internal view returns (TvmCell) {
        return tvm.buildStateInit({
            contr: Box,
            varInit: {_id: id},
            code: _buildBoxCode(addrAuthor)
        });
    }

    function _buildBoxCode(
        address addrAuthor
    ) internal view inline returns (TvmCell) {
        TvmBuilder salt;
        salt.store(addrAuthor);
        return tvm.setCodeSalt(_codeBox, salt.toCell());
    }
}