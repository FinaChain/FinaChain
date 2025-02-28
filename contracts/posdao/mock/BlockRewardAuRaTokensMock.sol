pragma solidity 0.5.10;

import './BlockRewardAuRaBaseMock.sol';
import '../base/BlockRewardAuRaTokens.sol';


contract BlockRewardAuRaTokensMock is BlockRewardAuRaTokens, BlockRewardAuRaBaseMock {
    function setEpochPoolReward(
        uint256 _stakingEpoch,
        address _poolMiningAddress,
        uint256 _tokenReward
    ) public payable {
        uint256 poolId = validatorSetContract.idByMiningAddress(_poolMiningAddress);
        require(_stakingEpoch != 0);
        require(_poolMiningAddress != address(0));
        require(poolId != 0);
        require(_tokenReward != 0);
        require(msg.value != 0);
        require(epochPoolTokenReward[_stakingEpoch][poolId] == 0);
        require(epochPoolNativeReward[_stakingEpoch][poolId] == 0);
        ITokenMinter tokenMinter = ITokenMinter(
            IStakingAuRaTokens(validatorSetContract.stakingContract()).erc677TokenContract()
        );
        tokenMinter.mintReward(_tokenReward);
        epochPoolTokenReward[_stakingEpoch][poolId] = _tokenReward;
        epochPoolNativeReward[_stakingEpoch][poolId] = msg.value;
        _epochsPoolGotRewardFor[poolId].push(_stakingEpoch);
    }
}
