const hre = require("hardhat");
const address = require('../address.json');


async function main() {
    const Greeter = await ethers.getContractFactory("Greeter")
    const greeter = await Greeter.attach(address.L2Greeter)
    const grestr=await greeter.greet()
    console.log(grestr)
  }

  // We recommend this pattern to be able to use async/await everywhere
  // and properly handle errors.
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });