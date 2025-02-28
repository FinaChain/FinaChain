pragma solidity 0.5.10;

import './StakingAuRaBaseMock.sol';
import '../base/StakingAuRaTokens.sol';


contract StakingAuRaTokensMock is StakingAuRaTokens, StakingAuRaBaseMock {
    function setErc677TokenContractMock(IERC677 _erc677TokenContract) public {
        erc677TokenContract = _erc677TokenContract;
    }
}
