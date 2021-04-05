pragma solidity ^0.7.4;

interface IQuotationData {

    function getCoverLength() external view returns (uint len);

    function getTotalSumAssured(bytes4 _curr) external view returns (uint amount);

    function getAllCoversOfUser(address _add) external view returns (uint[] memory allCover);

    function getTotalSumAssuredSC(address _add, bytes4 _curr) external view returns (uint amount);

}
