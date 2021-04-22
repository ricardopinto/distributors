// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

interface IPolicyBookFabric {
  enum ContractType {STABLECOIN, DEFI, CONTRACT, EXCHANGE}

  /// @notice Create new Policy Book contract, access: ANY
  /// @param _contract is Contract to create policy book for
  /// @param _contractType is Contract to create policy book for
  /// @param _description is bmiDAIx token desription for this policy book
  /// @param _projectSymbol replaces x in bmiDAIx token symbol  
  /// @return _policyBook is address of created contract
  function create(
    address _contract,
    ContractType _contractType,
    string calldata _description,
    string calldata _projectSymbol
  ) external returns (address);
}
