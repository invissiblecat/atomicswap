pragma ton-solidity >= 0.47.0;

contract Hashing {

    function secretToHash(bytes secret) public returns (uint256) {
        return tvm.hash(secret);
    }

}