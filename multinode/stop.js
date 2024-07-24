#!/usr/bin/env node

const fs = require("fs");
const toml = require('toml');
const shell = require('shelljs');
const path = require('path');
var SSH = require('simple-ssh');
const logsets = require("logsets")





/**
 * This script reads in a file containing raw transaction data, splits the data into individual transactions,
 * and sends them in batches of 1000 to the Arcology network.
 * 
 * @async
 * @function main
 * @returns {Promise<void>} A Promise that resolves when the transactions are sent.
 */
async function main() {
  var args = process.argv.splice(2);

  const data = fs.readFileSync(args[0], 'utf8');
  let nets;
  try {
    nets = JSON.parse(data);
  } catch (error) {
    console.error('Error parsing the file:', error);
  }

  const tasks = logsets.tasklist();
  for (i = 0; i < nets.nodes.length; i++) {
    try{
      tasks.add("Stop server on "+nets.nodes[i].ip);
      await stopCmd(nets.nodes[i]);
      tasks.complete()
    }catch(e){
        tasks.error(e)
    }
  }

}

async function stopCmd(node){
  var ssh = new SSH({
    host: node.ip,
    port: node.port,
    user: node.user,
    pass: node.pwd
  });

  await ssh.exec('cd devnet;./cli/stop.sh', {silent:true})
  .exec('rm -Rf devnet arcology')
  .start();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
