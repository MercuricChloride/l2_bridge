// deploy/00_deploy_your_contract.js

const { ethers } = require("hardhat");

const localChainId = "31337";

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

 //await deploy("BootcampBridge", {
 //  from: deployer,
 //  args: [ "0x2890bA17EfE978480615e330ecB65333b880928e", "0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA", "0x139732c3f717071843f90977D93400393BdF9664"],
 //  log: true,
 //});

await deploy("BootcampPlayer", {
  // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
  from: deployer,
   args: ["0xCf73231F28B7331BBe3124B907840A94851f9f11"],
  log: true,
});

};
module.exports.tags = ["YourContract"];
