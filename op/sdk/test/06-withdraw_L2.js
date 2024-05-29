const hre = require("hardhat");
const address = require('../address.json');
const fs = require('fs');

function updateTxHash(jsonfile,txhash){
  fs.readFile(jsonfile, 'utf8', (err, data) => {
    if (err) {
      console.error(err);
      return;
    }
    
    const jsonData = JSON.parse(data);
    
    jsonData.TxHash = txhash;
    
    
  
    fs.writeFile(jsonfile, JSON.stringify(jsonData), 'utf8', (err) => {
      if (err) {
        console.error(err);
      } else {
        console.log('JSON file updated successfully');
      }
    });
  });
}


async function main() {
    const Controller = await ethers.getContractFactory("FromL2_ControlL1Greeter")
    const controller = await Controller.deploy()
    await controller.deployed();
    console.log(`Testing with FromL2_ControlL1Greeter at ${controller.address}`)

    // tx = await controller.setGreeting(`Hardhat hello from L2 ${Date()}`,'0x4200000000000000000000000000000000000007',address.L1Greeter)
    tx = await controller.setGreeting(`Hello L1. I am L2.`,'0x4200000000000000000000000000000000000007',address.L1Greeter)
    console.log(tx)
    rcpt = await tx.wait()
    console.log(rcpt)
    updateTxHash('address.json',tx.hash);
  }

  // We recommend this pattern to be able to use async/await everywhere
  // and properly handle errors.
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });