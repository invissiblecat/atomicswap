pragma ton-solidity >= 0.47.0;

import './Box.sol';

contract BoxResolver {
    TvmCell _codeBox;

    // function resolveLLCWallet(address addrAuthor, uint32 id) public view returns (address addrLLCWallet) {
    //     TvmCell state = _buildLLCWalletState(addrAuthor, id);
    //     uint256 hashState = tvm.hash(state);
    //     addrLLCWallet = address.makeAddrStd(0, hashState);
    // }

    // function resolveLLCWalletCodeHash(address addrAuthor) external view returns (uint256 codeHashLLCWallet) {
    //     TvmCell code = _buildLLCWalletCode(addrAuthor);
    //     codeHashLLCWallet = tvm.hash(code);
    // }



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