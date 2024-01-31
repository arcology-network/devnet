// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const address = require('../address.json');

async function main() {
  const [owner] = await ethers.getSigners();
  const tx =await owner.sendTransaction({
    to: address.L1.L1StandardBridge,
    value: ethers.utils.parseEther("10.0"), // Sends exactly 1.0 ether
  });
  rcpt = await tx.wait()
  console.log(rcpt)

  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
