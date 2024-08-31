// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IERC20.sol"; 

contract ERC20Staking {
    IERC20 public stakingToken;
    uint256 public rewardRate;  // reward rate per second, scaled by 1e18
    uint256 public totalStaked;

    struct Stake {
        uint256 amount;
        uint256 lastStakedTime;
    }

    mapping(address => Stake) public stakes;
    mapping(address => uint256) public rewards;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount, uint256 reward);

    constructor(IERC20 _stakingToken, uint256 _rewardRate) {
        stakingToken = _stakingToken;
        rewardRate = _rewardRate;
    }

    function stake(uint256 _amount) external {
        require(_amount > 0, "Cannot stake 0 tokens");

        Stake storage userStake = stakes[msg.sender];
        _updateReward(msg.sender);

        stakingToken.transferFrom(msg.sender, address(this), _amount);
        userStake.amount += _amount;
        userStake.lastStakedTime = block.timestamp;
        totalStaked += _amount;

        emit Staked(msg.sender, _amount);
    }

    function withdraw() external {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No staked tokens");

        _updateReward(msg.sender);

        uint256 reward = rewards[msg.sender];
        uint256 amount = userStake.amount;

        rewards[msg.sender] = 0;
        userStake.amount = 0;
        userStake.lastStakedTime = 0;
        totalStaked -= amount;

        stakingToken.transfer(msg.sender, amount + reward);

        emit Withdrawn(msg.sender, amount, reward);
    }

    function _updateReward(address _user) internal {
        Stake storage userStake = stakes[_user];

        if (userStake.amount > 0) {
            uint256 timeStaked = block.timestamp - userStake.lastStakedTime;
            rewards[_user] += (timeStaked * rewardRate * userStake.amount) / 1e18;
            userStake.lastStakedTime = block.timestamp;
        }
    }
}
