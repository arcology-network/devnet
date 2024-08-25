const fs = require("fs");
const toml = require('toml');
const shell = require('shelljs');

/**
 * Execute a task.
 * @param {Object} tasks - The task list object.
 * @param {boolean} loop - Repeat or not this function.
 * @param {Object} nets - Network configuration.
 * @param {string} taskDesc - Function description.
 * @param {Function} fn - Function callback.
 * @param {Array} args - Function parameter.
 * @returns {Object} - An returned object from callback function.
 */
async function executeTask(tasks,loop,nets,taskDesc,fn,...args){
    if(loop){
      for (i = 0; i < nets.nodes.length; i++) {
        try{
            tasks.add(taskDesc+" "+nets.nodes[i].ip);
            await fn(...args,i);
            tasks.complete();
          }catch(e){
              tasks.error(e);
          }
      }
    }else{
      var ret;
      try{
        tasks.add(taskDesc)
        ret=await fn(...args);
        tasks.complete();
      }catch(e){
          tasks.error(e);
      }
      return ret;
    }
    
  }
  /**
 * Loading network configuration.
 * @returns {Object} - An object containing the context of network configuration.
 */
  async function loadNetConfigs(cfgfile){
    const data = fs.readFileSync(cfgfile, 'utf8');
    try {
      return JSON.parse(data);
    } catch (error) {
      console.error('Error parsing the file:', error);
    }
  }
  


module.exports = {
    executeTask,
    loadNetConfigs,
}