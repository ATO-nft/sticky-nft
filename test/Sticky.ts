const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers")
const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("Sticky NFT", function () {

  async function deployContracts() {
    const [alice, bob] = await ethers.getSigners();
    const uri = "hello"
    const name = "Sticky"
    const symbol = "STICKY"
    const target = bob.address
    const Sticky = await ethers.getContractFactory("Sticky")
    const sticky = await Sticky.deploy(uri, name, symbol, target)
    return { sticky, alice, bob }
  }

  describe("Deployment", function () {
    it("Should return the right owner", async function () {
      const { sticky, alice } = await loadFixture(deployContracts);
      expect(await sticky.owner()).to.equal(alice.address)
    })
    it("Should return the target's address", async function () {
      const { sticky, bob } = await loadFixture(deployContracts);
      expect(await sticky.ownerOf(0)).to.equal(bob.address)
    })
  })

  describe("Interactions", function () {
    xit("Target can't transfer the NFT", async function () {
      const { sticky, bob } = await loadFixture(deployContracts);
      
    });
    xit("Target can't burn the NFT", async function () {
      
    })
    xit("Owner can burn the NFT", async function () {
      
    })
    xit("Owner can edit the metadata", async function () {
      
    })
  })
})