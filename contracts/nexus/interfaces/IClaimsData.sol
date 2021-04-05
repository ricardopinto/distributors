pragma solidity ^0.7.4;

interface IClaimsData {

    function getAllClaimsByAddress(address _member) external view returns (uint[] memory);
}
