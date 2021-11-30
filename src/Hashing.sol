pragma solidity >= 0.5.0;

contract Hashing {

    function secretToHash(string secret) public returns (uint256) {
        tvm.accept();
        return sha256(secret);
    }

}