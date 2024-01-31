const hre = require("hardhat");
const address = require('../address.json');


async function main() {
    const Controller = await ethers.getContractFactory("FromL1_ControlL2Greeter")
    const controller = await Controller.deploy()
    await controller.deployed();
    console.log(`Testing with FromL1_ControlL2Greeter at ${controller.address}`)

    // tx = await controller.setGreeting(`Hardhat hello from L1 ${Date()}`,address.L1.L1CrossDomainMessenger,address.L2Greeter)
    tx = await controller.setGreeting(`Hello L2.I am L1.`,address.L1.L1CrossDomainMessenger,address.L2Greeter)
    console.log(tx)
    rcpt = await tx.wait()
    console.log(rcpt)
  }

  // We recommend this pattern to be able to use async/await everywhere
  // and properly handle errors.
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });