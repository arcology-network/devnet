#!/usr/bin/env node

const fs = require("fs");
const toml = require('toml');
const shell = require('shelljs');
const path = require('path');
var SSH = require('simple-ssh');
var util = require('./util') 
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
  if(args.length<3){
    console.log('Please provide network configuration 、workspace and docker flag.');
    return;
  }

  const isDocker=args[2]=="true"


  const tasks = logsets.tasklist();
  let nets,peers,version;
  var reset=false

  if(isDocker){
    if(args.length<4){
      version="latest"
      // console.log('Please provide version of docker image.');
      // return;
    }else{
      version=args[3]
      if(args.length==5){
        reset=args[4]=='true'
      }
    }
  }

  

  nets=await util.executeTask(tasks,false,nets,"Loading network configuration information",util.loadNetConfigs,args[0]);
  
  const workpath=args[1]+'/workdata';
  shell.rm('-Rf', workpath);
  await util.executeTask(tasks,false,nets,"Create node configuration information",CreateConfiguration,nets.nodes.length,workpath);

  const devnetpkg=workpath+'/devnet.tar'
  if( !isDocker){
    await util.executeTask(tasks,false,nets,"Compress devnet package",compressDevnet,devnetpkg);
  }


  peers=await util.executeTask(tasks,false,nets,"Collecting peer information",collectPeers,nets,workpath);

  await util.executeTask(tasks,true,nets,"Create global.json for",makeGlobal,nets,workpath,peers);

  if(isDocker){
    await util.executeTask(tasks,true,nets,"Copy docker install script ",CpScripts,workpath);
  }
  
  if(isDocker){
    await util.executeTask(tasks,true,nets,"deploy on ",deployDocker,nets,workpath,version,reset);
  }else{
    await util.executeTask(tasks,true,nets,"deploy on ",deploy,nets,workpath,devnetpkg);
  }
}

async function deploy(nets,workpath,devnetpkg,idx){
  const node=nets.nodes[idx]
  var localfile = workpath+'/s' + idx + '.tar'
  shell.exec('cd '+workpath+';tar -zcf s' + idx + '.tar s' + idx+'/');

  await sshcpBypass(false,node.ip, node.port, node.user, node.pwd, localfile, node.basepath + '/s' + idx + '.tar');
  await sshcpBypass(false,node.ip, node.port, node.user, node.pwd, devnetpkg, node.basepath + '/devnet.tar');
  
  var ssh = new SSH({
    host: node.ip,
    port: node.port,
    user: node.user,
    pass: node.pwd
  });

  ssh
  .exec('tar -zxf s'+idx+'.tar')
  .exec('tar -zxf devnet.tar')
  .exec('mv s'+idx+'/arcology arcology')
  .exec('mv -f s'+idx+'/global.json devnet/arcology/configs/global.json')
  .exec('rm -Rf devnet.tar s'+idx+' s'+idx+'.tar')
  .exec('cd devnet;./cli/install.sh -p '+node.ip, {pty: true})
  .exec('cd devnet;./cli/start.sh -f http://'+node.ip+':7545 -s http://'+node.ip+':8545 -r true -m true &')
  .start();
}

async function compressDevnet(devnetpkg){
  shell.exec('cd ../..;tar -zcf '+devnetpkg+' devnet/');
}

async function CreateConfiguration(nodesize,workpath){
  shell.exec('../arcology/bin/arcology testnet --v=' + nodesize + ' --o='+workpath,{silent:true});
}

async function CpScripts(workpath,idx){
  shell.cp('-Rf','docker.sh',workpath+'/s' + idx +'/docker.sh');
}


async function deployDocker(nets,workpath,version,clear,idx){
  const node=nets.nodes[idx]
  var localfile = workpath+'/s' + idx + '.tar'
  shell.exec('cd '+workpath+';tar -zcf s' + idx + '.tar s' + idx+'/');

  await sshcpBypass(false,node.ip, node.port, node.user, node.pwd, localfile, node.basepath + '/s' + idx + '.tar');
  
  var ssh = new SSH({
    host: node.ip,
    port: node.port,
    user: node.user,
    pass: node.pwd
  });

  let containerID
  if(version=="latest"){
    containerID='arcologynetwork/devnet'
  }else{
    containerID='arcologynetwork/devnet:'+version
  }

  var clearCmd="echo ''"
  if(clear){
    clearCmd="sudo docker rmi arcologynetwork/devnet:latest"
  }

  ssh
  .exec('tar -zxf s'+idx+'.tar')
  .exec('cd s'+idx+';./docker.sh', {
    pty: true,
    // out: console.log.bind(console)
  })
  .exec(clearCmd, {
    pty: true,
    // out: console.log.bind(console)
  })
  .exec('sudo docker run -itd --name l2 -p 8545:8545 -p 26656:26656 -p 9191:9191 -p 9192:9192 -p 9292:9292 '+containerID+' -f http://'+node.ip+':7545 -s http://'+node.ip+':8545 -r true -m true -d true', {
    pty: true,
    // out: console.log.bind(console)
  }) //only start container
  .exec('sudo docker cp s'+idx+'/arcology l2:/root', {
    pty: true,
    // out: console.log.bind(console)
  })
  .exec('sudo docker cp s'+idx+'/global.json l2:/devnet/arcology/configs/global.json', {
    pty: true,
    // out: console.log.bind(console)
  })
  .exec("sudo docker exec l2 /bin/bash -c './cli/start.sh -f http://"+node.ip+":7545 -b http://"+node.ip+":3500 -s http://"+node.ip+":8545 -r true -m true'", {
    pty: true,
    // out: console.log.bind(console)
  })
  .exec('rm -Rf devnet.tar s'+idx+' s'+idx+'.tar', {
    pty: true,
    // out: console.log.bind(console)
  })
  .start();



}


async function collectPeers(nets,workpath){
  const config = toml.parse(fs.readFileSync(workpath+'/node0/config/config.toml', 'utf-8'));
  let peers = config.p2p.persistent_peers;


  for (i = 0; i < nets.nodes.length; i++) {
    shell.mkdir('-p', workpath+'/s' + i + '/arcology');
    shell.cp('-Rf', workpath+'/node' + i, workpath+'/s' + i + '/arcology/main');
    shell.rm('-Rf', workpath+'/node' + i);

    peers = peers.replace("node" + i, nets.nodes[i].ip);
  }
  return peers
}

async function makeGlobal(nets,workpath,peers,idx){
  const net=nets.nodes[idx];
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
