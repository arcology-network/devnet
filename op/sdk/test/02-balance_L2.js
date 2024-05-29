// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const address = require('../address.json');

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
  const [owner] = await ethers.getSigners();
  const execpted=ethers.utils.parseEther("10.0")
  let query = true
  while(query){
    const balance = await ethers.provider.getBalance(owner.address);
    console.log(balance)
    await sleep(5000)
    if(balance.eq(execpted)){
      console.log('transfer successfully')
      query=false
    }
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
