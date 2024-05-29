const hre = require("hardhat");
const fs = require('fs');

function updateAddress(jsonfile,contractAddress){
  fs.readFile(jsonfile, 'utf8', (err, data) => {
    if (err) {
      console.error(err);
      return;
    }
    
    const jsonData = JSON.parse(data);
    if(hre.network.name=='L1'){
      jsonData.L1Greeter = contractAddress;
    }else{
      jsonData.L2Greeter = contractAddress;
    }
    
  
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

    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy("Hello, world!");
    await greeter.deployed();
    console.log(`Testing with greeter at ${greeter.address}`)

    updateAddress('address.json',greeter.address);

  }

  // We recommend this pattern to be able to use async/await everywhere
  // and properly handle errors.
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });