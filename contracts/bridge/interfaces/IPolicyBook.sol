// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;
pragma experimental ABIEncoderV2;

import "./IPolicyBookFabric.sol";

interface IPolicyBook {
  enum WithdrawalStatus {NONE, PENDING, READY, EXPIRED, IN_QUEUE}

  struct PolicyHolder {
    uint256 coverTokens;
    uint256 startEpochNumber;
    uint256 endEpochNumber;

    uint256 payed;
    uint256 payedToProtocol;
  }

  struct WithdrawalInfo {
    uint256 withdrawalAmount;
    uint256 readyToWithdrawDate;
  }

  function whitelisted() external view returns (bool);

  function EPOCH_DURATION() external view returns (uint256);

  function totalLiquidity() external view returns (uint256);

  function totalCoverTokens() external view returns (uint256);

  function epochStartTime() external view returns (uint256);

  function aggregatedQueueAmount() external view returns (uint256);

  function whitelist(bool _whitelisted) external;

  // @TODO: should we let DAO to change contract address?
  /// @notice Returns address of contract this PolicyBook covers, access: ANY
  /// @return _contract is address of covered contract
  function insuranceContractAddress() external view returns (address _contract);

  /// @notice Returns type of contract this PolicyBook covers, access: ANY
  /// @return _type is type of contract
  function contractType() external view returns (IPolicyBookFabric.ContractType _type);    

  /// @notice get DAI equivalent
  function convertDAIXtoDAI(uint256 _amount) external view returns (uint256);    

  /// @notice get DAIx equivalent
  function convertDAIToDAIx(uint256 _amount) external view returns (uint256);

  function __PolicyBook_init(
    address _insuranceContract,
    IPolicyBookFabric.ContractType _contractType,    
    string calldata _description,
    string calldata _projectSymbol    
  ) external;

  function getWithdrawalStatus(address _userAddr) external view returns (WithdrawalStatus);

  /// @notice returns how many BMI tokens needs to approve in order to submit a claim
  function getClaimApprovalAmount(address user) external view returns (uint256);
  
  /// @notice submits new claim of the policy book
  function submitClaimAndInitializeVoting() external;

  /// @notice submits new appeal claim of the policy book
  function submitAppealAndInitializeVoting() external;

  /// @notice updates info on claim acceptance
  function commitClaim(address claimer, uint256 claimAmount) external;

  /// @notice Let user to buy policy by supplying DAI, access: ANY
  /// @param _durationSeconds is number of seconds to cover
  /// @param _coverTokens is number of tokens to cover  
  function buyPolicy(
    uint256 _durationSeconds,
    uint256 _coverTokens
  ) external;
  
  /// @notice converts epochs to seconds considering current epoch end time
  function getTotalSecondsOfEpochs(uint256 _epochs, uint256 _currentEpochNumber) 
    external 
    view 
    returns (uint256);

  /// @notice returns the future update
  function getUpdatedEpochsInfo() 
    external 
    view
    returns (
      uint256 lastEpochUpdate, 
      uint256 newEpochNumber, 
      uint256 newTotalCoverTokens
    ); 

  /// @notice Let user to add liquidity by supplying DAI, access: ANY
  /// @param _liqudityAmount is amount of DAI tokens to secure
  function addLiquidity(uint256 _liqudityAmount) external;

  /// @notice Let liquidityMining contract to add liqiudity for another user by supplying DAI, access: ONLY LM
  /// @param _liquidityHolderAddr is address of address to assign cover
  /// @param _liqudityAmount is amount of DAI tokens to secure
  function addLiquidityFromLM(address _liquidityHolderAddr, uint256 _liqudityAmount) external;

  function addLiquidityAndStake(uint256 _liquidityAmount, uint256 _bmiDAIxAmount) external;

  function addLiquidityAndStakeWithPermit(
    uint256 _liquidityAmount,      
    uint256 _bmiDAIxAmount,    
    uint8 v,
    bytes32 r, 
    bytes32 s
  ) external;

  function isExitFromQueuePossible(address _userAddr) external view returns (bool, uint256);

  function updateEpochsInfo() external;

  function updateWithdrawalQueue(uint256 _lastIndexToUpdate) external;

  function leaveQueue() external;

  function unlockTokens() external;

  function getWithdrawalQueue() external view returns (address[] memory _resultArr);

  function requestWithdrawal(uint256 _tokensToWithdraw) external;

  function requestWithdrawalWithPermit(
    uint256 _tokensToWithdraw,
    uint8 _v,
    bytes32 _r,
    bytes32 _s
  ) external;

  /// @notice Let user to withdraw deposited liqiudity, access: ANY
  function withdrawLiquidity() external;  

  /// @notice Getting user stats, access: ANY 
  function userStats(address _user)
    external
    view    
    returns (
      PolicyHolder memory
    );

  /// @notice Getting number stats, access: ANY
  /// @return _maxCapacities is a max token amount that a user can buy
  /// @return _totalDaiLiquidity is PolicyBook's liquidity
  /// @return _annualProfitYields is its APY  
  function numberStats()
    external
    view
    returns (
      uint256 _maxCapacities,
      uint256 _totalDaiLiquidity,
      uint256 _annualProfitYields
    );

  /// @notice Getting stats, access: ANY
  /// @return _name is the name of PolicyBook
  /// @return _insuredContract is an addres of insured contract
  /// @return _contractType is a type of insured contract  
  /// @return _whitelisted is a state of whitelisting
  function stats()
    external
    view
    returns (
      string memory _name,
      address _insuredContract,
      IPolicyBookFabric.ContractType _contractType,
      bool _whitelisted
    );
}
