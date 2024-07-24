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
  if(args.length<2){
    console.log('Please provide the RPC provider and the file containing the transaction data.');
    return;
  }

  const tasks = logsets.tasklist()

  let nets,peers;

  try{
    tasks.add("Loading network configuration information")
    nets=await loadNetConfigs(args[0])
    tasks.complete()
  }catch(e){
      tasks.error(e)
  }

  const workpath=args[1]+'/workdata';
  shell.rm('-Rf', workpath);
  try{
    tasks.add("Create node configuration information")
    shell.exec('../arcology/bin/arcology testnet --v=' + nets.nodes.length + ' --o='+workpath,{silent:true});
    tasks.complete()
  }catch(e){
      tasks.error(e)
  }


  const devnetpkg=workpath+'/devnet.tar'
  try{
    tasks.add("Compress devnet package")
    shell.exec('cd ../..;tar -zcf '+devnetpkg+' devnet/');
    tasks.complete()
  }catch(e){
      tasks.error(e)
  }

  try{
    tasks.add("Collecting peer information")
    peers=await collectPeers(nets,workpath);
    tasks.complete()
  }catch(e){
      tasks.error(e)
  }

  for (i = 0; i < nets.nodes.length; i++) {
    try{
      tasks.add("Create global.json for "+nets.nodes[i].ip);
      await makeGlobal(nets,nets.nodes[i],workpath,peers,i);
      tasks.complete()
    }catch(e){
        tasks.error(e)
    }
  }

  for (i = 0; i < nets.nodes.length; i++) {
    try{
        tasks.add("deploy on "+nets.nodes[i].ip);
        await deploy(nets.nodes[i],i,workpath,devnetpkg);
        tasks.complete()
      }catch(e){
          tasks.error(e)
      }
  }

}

async function deploy(node,i,workpath,devnetpkg){
  var localfile = workpath+'/s' + i + '.tar'
  shell.exec('cd '+workpath+';tar -zcf s' + i + '.tar s' + i+'/');

  await sshcpBypass(false,node.ip, node.port, node.user, node.pwd, localfile, node.basepath + '/s' + i + '.tar');
  await sshcpBypass(false,node.ip, node.port, node.user, node.pwd, devnetpkg, node.basepath + '/devnet.tar');
  
  var ssh = new SSH({
    host: node.ip,
    port: node.port,
    user: node.user,
    pass: node.pwd
  });

  ssh
  .exec('tar -zxf s'+i+'.tar')
  .exec('tar -zxf devnet.tar')
  .exec('mv s'+i+'/arcology arcology')
  .exec('mv -f s'+i+'/global.json devnet/arcology/configs/global.json')
  .exec('rm -Rf devnet.tar s'+i+' s'+i+'.tar')
  .exec('cd devnet;./cli/install.sh -p '+node.ip, {silent:true,pty: true})
  .start();
}

async function collectPeers(nets,workpath){
  const config = toml.parse(fs.readFileSync(workpath+'/node0/config/config.toml', 'utf-8'));
  // console.log(config.p2p.persistent_peers);
  let peers = config.p2p.persistent_peers;


  for (i = 0; i < nets.nodes.length; i++) {
    shell.mkdir('-p', workpath+'/s' + i + '/arcology');
    shell.cp('-Rf', workpath+'/node' + i, workpath+'/s' + i + '/arcology/main');
    shell.rm('-Rf', workpath+'/node' + i);

    peers = peers.replace("node" + i, nets.nodes[i].ip);
  }
  return peers
}
async function loadNetConfigs(cfgfile){
  const data = fs.readFileSync(cfgfile, 'utf8');
  try {
    return JSON.parse(data);
  } catch (error) {
    console.error('Error parsing the file:', error);
  }
}

async function makeGlobal(nets,net,workpath,peers,idx){
  const globalfile = workpath+'/s' + idx + '/global.json';
  shell.cp('-Rf', '../arcology/configs/global.json', globalfile)
  
  const data = fs.readFileSync(globalfile, 'utf-8');
  let global
  try {
    global = JSON.parse(data);
  } catch (error) {
    console.error('Error parsing the file:', error);
  }
  global.cluster_name = 'node' + idx;
  global.cluster_id = idx;
  global.persistent_peers = peers;
  global.p2p_gateway.host = net.ip
  global.p2p_conn.host = net.ip

  let peerlist = new Array();
  var peer
  for (j = 0; j < nets.nodes.length; j++) {
    if (idx == j) {
      continue
    }
    peer = {
      "id": "node" + j,
      "host": nets.nodes[j].ip,
      "port": 9192
    }
    peerlist.push(peer);
  }
  global.p2p_peers = peerlist

  fs.writeFileSync(globalfile, JSON.stringify(global, null, 2));
}

async function sshcpBypass(ispath,ip, port, user, pwd, localfile, remotefile) {
  var cmd='sshpass -p '+pwd+' scp -P '+port+' ';
  if(ispath){
    cmd=cmd+' -r '
  }
  cmd=cmd+localfile+' '+user+'@' + ip + ':'+remotefile;
  // console.log(cmd)
  shell.exec(cmd).stdout;
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
