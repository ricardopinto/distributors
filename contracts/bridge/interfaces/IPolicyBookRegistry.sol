// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "./IPolicyBookFabric.sol";
pragma experimental ABIEncoderV2;

interface IPolicyBookRegistry {
  struct PolicyBookStats {
    string name;
    address insuredContract;
    IPolicyBookFabric.ContractType contractType;
    uint256 maxCapacity;
    uint256 totalDaiLiquidity;
    uint256 APY;
    bool whitelisted;
  }

  /// @notice Adds PolicyBook to registry, access: PolicyFabric
  function add(address _insuredContract, address _policyBook) external;

  /// @notice Checks if provided address is a PolicyBook
  function isPolicyBook(address _contract) external view returns (bool);

  /// @notice Returns number of registered PolicyBooks, access: ANY
  function count() external view returns (uint256);

  /// @notice Listing registered PolicyBooks, access: ANY
  /// @return _policyBooks is array of registered PolicyBook addresses
  function list(uint256 _offset, uint256 _limit)
    external
    view
    returns (
      address[] memory _policyBooks
    );

  /// @notice Listing registered PolicyBooks, access: ANY
  function listWithStats(uint256 _offset, uint256 _limit)
    external
    view
    returns (
      address[] memory _policyBooks,
      PolicyBookStats[] memory _stats
    );

  /// @notice Return existing Policy Book contract, access: ANY
  /// @param _contract is contract address to lookup for created IPolicyBook
  function policyBookFor(address _contract) external view returns (address);

  /// @notice Getting stats from policy books, access: ANY
  /// @param _policyBooks is list of PolicyBooks addresses
  function stats(address[] calldata _policyBooks)
    external
    view
    returns (
      PolicyBookStats[] memory _stats
    );

  /// @notice Getting stats from policy books, access: ANY
  /// @param _insuredContracts is list of insuredContracts in registry
  function statsByInsuredContracts(address[] calldata _insuredContracts)
    external
    view
    returns (
      PolicyBookStats[] memory _stats
    );
}
