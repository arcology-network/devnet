const hre = require("hardhat");
const address = require('../address.json');
const nets = require('../network.json');
const sdk = require("@eth-optimism/sdk")

async function TxStatus(txhash,status) {
  return (await crossChainMessenger.getMessageStatus(txhash)) == status
}

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function MessageStatus(status) {
  switch(status){
    case sdk.MessageStatus.STATE_ROOT_NOT_PUBLISHED:
      return status+"_STATE_ROOT_NOT_PUBLISHED";
    case sdk.MessageStatus.READY_TO_PROVE:
      return status+"_READY_TO_PROVE";
    case sdk.MessageStatus.IN_CHALLENGE_PERIOD:
      return status+"_IN_CHALLENGE_PERIOD";
    case sdk.MessageStatus.READY_FOR_RELAY:
      return status+"_READY_FOR_RELAY";
    default:
      return status+"_NOT_DEFINED";
  }
}

async function main() {
  const Greeter = await ethers.getContractFactory("Greeter")
  const greeter = await Greeter.attach(address.L1Greeter)
  let grestr=await greeter.greet()
  console.log(`greet message : ${grestr}`)
  
  l1Provider = new ethers.providers.JsonRpcProvider(nets.L1.url)
  l2Provider = new ethers.providers.JsonRpcProvider(nets.L2.url)
  l1Signer = await ethers.getSigner()

  crossChainMessenger = new sdk.CrossChainMessenger({ 
    l1ChainId: nets.L1.chainId,
    l2ChainId: nets.L2.chainId,
    l1SignerOrProvider: l1Signer, 
    l2SignerOrProvider: l2Provider,
    bedrock: true,
    contracts: {
      l1: address.L1,
      l2: sdk.DEFAULT_L2_CONTRACT_ADDRESSES,
    }
  })

  
  hash = address.TxHash
  let query = true
  let IsProved = false
  let _txStatus=sdk.MessageStatus.STATE_ROOT_NOT_PUBLISHED;

  while(query){
    switch(_txStatus){
      case sdk.MessageStatus.READY_TO_PROVE:
        if(IsProved){
          await sleep(5000);
          _txStatus=await crossChainMessenger.getMessageStatus(hash);
          console.log(`current message status is ${MessageStatus(_txStatus)}`);
        }else{
          let tx = await crossChainMessenger.proveMessage(hash);
          let rcpt = await tx.wait();
          console.log(`proveMessage result ${rcpt}`);
          IsProved=true;
        }
        break; 
      case sdk.MessageStatus.READY_FOR_RELAY:
        await sleep(13000);
        let tx = await crossChainMessenger.finalizeMessage(hash);
        let rcpt = await tx.wait();
        console.log(`finalizeMessage result ${rcpt}`);
        query=false;
        break;
      default:
        await sleep(5000);
        _txStatus=await crossChainMessenger.getMessageStatus(hash)
        console.log(`current message status is ${MessageStatus(_txStatus)}`)
    }
  }

  grestr=await greeter.greet()
  console.log(`final greet message : ${grestr}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});