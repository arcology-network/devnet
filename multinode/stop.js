#!/usr/bin/env node

const fs = require("fs");
var SSH = require('simple-ssh');
var util = require('./util') 
const logsets = require("logsets")





/**
 * This script reads in a file containing raw transaction data, splits the data into individual transactions,
 * and sends them in batches of 1000 to the Arcology network.
 * 
 * @async
 * @function main
 * @returns .
 */
async function main() {
  var args = process.argv.splice(2);
  if(args.length<2){
    console.log('Please provide network configuration and docker flag.');
    return;
  }

  const isDocker=args[1]=="true"
  let nets;

  // const data = fs.readFileSync(args[0], 'utf8');
  // 
  // try {
  //   nets = JSON.parse(data);
  // } catch (error) {
  //   console.error('Error parsing the file:', error);
  // }
  const tasks = logsets.tasklist();
  
  nets=await util.executeTask(tasks,false,nets,"Loading network configuration information",util.loadNetConfigs,args[0]);

  await util.executeTask(tasks,true,nets,"Stop server on",stopCmd,nets,isDocker)

}

async function stopCmd(nets,isdocker,idx){
  const node=nets.nodes[idx]
  var ssh = new SSH({
    host: node.ip,
    port: node.port,
    user: node.user,
    pass: node.pwd
  });

  if(isdocker){
    await ssh.exec('sudo docker stop l2 && sudo docker rm l2', {
      silent:true,
      pty: true
    })
    .exec('rm -Rf devnet arcology')
    .start();
  }else{
    await ssh.exec('cd devnet;./cli/stop.sh -m true', {silent:true})
    .exec('rm -Rf devnet arcology')
    .start();
  }
}



// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
