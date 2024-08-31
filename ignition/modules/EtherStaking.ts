import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ONE_GWEI: bigint = 1_000_000_000n; // Example initial funding (can be modified)

const EtherStakingModule = buildModule("EtherStakingModule", (m) => {

  const etherStaking = m.contract("EtherStaking");

  return { etherStaking };
});

export default EtherStakingModule;
