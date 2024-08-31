// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EtherStaking {
    struct Stake {
        uint256 amount;
        uint256 startTime;
    }

    mapping(address => Stake) public stakes;
    uint256 public rewardRatePerSecond = 1; // Example reward rate per second

    function stakeEther() external payable {
        require(msg.value > 0, "Must stake a positive amount");
        require(stakes[msg.sender].amount == 0, "Already staking");

        stakes[msg.sender] = Stake({
            amount: msg.value,
            startTime: block.timestamp
        });
    }

    function calculateReward(address user) public view returns (uint256) {
        Stake memory userStake = stakes[user];
        if (userStake.amount == 0) return 0;

        uint256 stakingDuration = block.timestamp - userStake.startTime;
        return stakingDuration * rewardRatePerSecond;
    }

    function withdrawStake() external {
        Stake memory userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No staked Ether");

        uint256 reward = calculateReward(msg.sender);
        uint256 totalAmount = userStake.amount + reward;

        stakes[msg.sender].amount = 0;
        payable(msg.sender).transfer(totalAmount);
    }
}
