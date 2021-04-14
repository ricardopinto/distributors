pragma solidity ^0.7.4;

interface IPooledStaking {

    event UnstakeRequested(address indexed contractAddress, address indexed staker, uint amount, uint unstakeAt);

    function contractStake(address contractAddress) external view returns (uint);

    function depositAndStake(uint amount, address[] calldata _contracts, uint[] calldata _stakes) external;

    function hasPendingActions() external view returns (bool);

    function hasPendingBurns() external view returns (bool);

    function hasPendingUnstakeRequests() external view returns (bool);

    function hasPendingRewards() external view returns (bool);

    function lastUnstakeRequestId() external view returns (uint);

    function pushRewards(address[] calldata contractAddresses) external;

    function processPendingActions(uint maxIterations) external returns (bool finished);

    function stakerReward(address staker) external view returns (uint);

    function stakerContractsArray(address staker) external view returns (address[] memory);

    function stakerContractStake(address staker, address contractAddress) external view returns (uint);

    function requestUnstake(address[] calldata _contracts, uint[] calldata _amounts,uint _insertAfter) external;

    function withdraw(uint amount) external;

    function stakerContractPendingUnstakeTotal(address staker, address contractAddress) external view returns (uint);

    function withdrawReward(address stakerAddress) external;

    function stakerMaxWithdrawable(address stakerAddress) external view returns (uint);

    function UNSTAKE_LOCK_TIME() external view returns (uint);

    function MIN_STAKE() external view returns (uint);

}
