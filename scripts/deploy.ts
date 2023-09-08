const color = require("cli-color")
var msg = color.xterm(39).bgXterm(128)
import hre, { ethers, network } from 'hardhat'
import fs from 'fs'

async function main() {

  const uri = "hello"
  const name = "Sticky"
  const symbol = "STICKY"
  const target = "0x70456d078950db075283931D9bE2E01B49f3e71e"
  const Sticky = await ethers.getContractFactory("Sticky")
  const sticky = await Sticky.deploy(uri, name, symbol, target)

  const recordAddress = {
    "contractAddress": await sticky.getAddress()
  }
  
  const content = JSON.stringify(recordAddress, null, 2)
  fs.writeFileSync('store.json', content)

  console.log('Sticky NFT contract deployed:', msg(await sticky.getAddress()))

  try {
    console.log("\nEtherscan verification in progress...")
    console.log("\nWaiting for 6 block confirmations (you can skip this part)")
    await sticky.deploymentTransaction()?.wait(6)
    await hre.run("verify:verify", { network: network.name, address: await sticky.getAddress(), constructorArguments: [uri, name, symbol, target], })
    console.log("Etherscan verification done. ✅")
  } catch (error) {
    console.error(error)
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});