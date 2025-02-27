import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(`Deploying MY NFT samrt contract: ${deployer.address}`);

  
  const Nft = await ethers.getContractFactory("HappyNFT");
  const nft = await Nft.deploy(deployer.address);
  await nft.waitForDeployment();
  console.log(`Happy NFT deployed at: ${await nft.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});