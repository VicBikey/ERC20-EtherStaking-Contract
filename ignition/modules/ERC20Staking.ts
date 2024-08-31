import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ERC20StakingModule = buildModule("ERC20StakingModule", (m) => {

  const erc20tokenStaking = m.contract("ERC20Staking");

  return { erc20tokenStaking };
});

export default ERC20StakingModule;
