const { expect } = require("chai");
const { ethers } = require("hardhat");
const SpaceICOJson = require("../artifacts/contracts/SpaceICO.sol/SpaceICO.json");
const SpaceCoinJson = require("../artifacts/contracts/SpaceCoin.sol/SpaceCoin.json");

describe("SpaceContract", function () {
  
  let spaceContract;


  before (async function () {
    



  });

  // it("Should deploy an ICO contract", async function () {
  //     expect(spaceContract.address).to.be.ok;
  // });


  it("Should work", async function () {

    const [owner, investor1, investor2, investor3] = await ethers.getSigners();

    const SpaceICO = await ethers.getContractFactory("SpaceICO");
    const spaceICO = await SpaceICO.connect(owner).deploy();
    await spaceICO.deployed();

    const SpaceCoin = await ethers.getContractFactory("SpaceCoin");
    spaceCoin = await SpaceCoin.connect(owner).deploy("0xb27f27bfe5904e7a6dCc3015eCdd37A878784b6c");
    await spaceCoin.deployed();

    console.log("SPACECOIN ", spaceCoin.address);

    await spaceICO.connect(owner).setSpaceCoin(spaceCoin.address);

    console.log("spaceICO ", spaceICO.address);

    console.log("Owner : " + owner.address);
    console.log("investor1 : " + investor1.address);
    console.log("investor2 : " + investor2.address);
    console.log("investor3 : " + investor3.address);
    
    // console.log(ethers.utils.parseEther('3'));

    await spaceICO.connect(owner).addWhitelist( investor1.address );
    await spaceICO.connect(owner).addWhitelist( investor2.address );
    await spaceICO.connect(owner).addWhitelist( investor3.address );

    await spaceICO.connect(owner).deposit( { value: ethers.utils.parseEther('1500') } );
    await spaceICO.connect(investor1).deposit({ value: ethers.utils.parseEther('1500') });

    // console.log("TOKENS", await spaceICO.connect(owner).getBalance());

    await spaceICO.connect(owner).stepPhase();

    await spaceICO.connect(investor2).deposit({ value: ethers.utils.parseEther('1000') });

    await spaceICO.connect(owner).stepPhase();

    await spaceICO.connect(investor3).deposit({ value: ethers.utils.parseEther('5000') });

    await spaceICO.connect(investor2).deposit({ value: ethers.utils.parseEther('1000') });

    // await spaceICO.connect(owner).withdraw(owner.address);

    console.log("INVEST 1" , await spaceCoin.connect(owner).balanceOf(investor2.address));

    // console.log(await spaceICO.connect(owner).getBalanceTokens());


  });
});
