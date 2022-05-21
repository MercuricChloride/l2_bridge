// deploy/00_deploy_your_contract.js

const { ethers } = require("hardhat");

//const localChainId = "31337";

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = getChainId();

  // goerli deployed address: 0xdf4804Dd7361FE85f3fd0108eb97f485E464A49B

  await deploy("BootcampBridge", {
   from: deployer,
   args: [ "0x2890bA17EfE978480615e330ecB65333b880928e", "0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA"],
   log: false,
  });
  const bridge = await ethers.getContract("BootcampBridge", deployer);

  let tried = [0];
  let start = 0;
  let toMint = [];

  for(i=0; i<140;i++){
    start = tried[tried.length-1];
    toMint = [];
    for(start; toMint.length < i;start++){
      toMint.push(start);
    }
    console.log(`minting ${i+1}`);
    await bridge.claimPlayers(toMint)
    console.log(`minted tokens ${toMint[0]} to ${toMint[toMint.length-1]}`)
    tried.push(start+1);
  }

  // mumbai deployed address: 0xdf4804dd7361fe85f3fd0108eb97f485e464a49b
  // await deploy("BootcampPlayer", {
  //   from: deployer,
  //   args: ["0xCf73231F28B7331BBe3124B907840A94851f9f11"],
  //   log: true,
  //  waitConfirmations: 15
  // });

  // const Bridge = await ethers.getContract("YourContractRoot", deployer)
  // const Child = await ethers.getContract("YourContractChild", deployer)

  // await Bridge.setFxChildTunnel(Child.address)

  // await Child.setFxRootTunnel(Bridge.address)

};
module.exports.tags = ["YourContract"];
