pragma solidity >= 0.5.0;

contract Hashing {

    function secretToHash(bytes secret) public returns (uint256) {
        tvm.accept();
        return tvm.hash(secret);
    }

}