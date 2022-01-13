import { ethers } from "ethers"
import { BigNumber} from "@ethersproject/bignumber";
import SpaceContractJSON from '../../artifacts/contracts/SpaceContract.sol/SpaceContract.json'

const {

    BigNumber,
    FixedFormat,
    FixedNumber,
    formatFixed,
    parseFixed,
    BigNumberish

} = require("@ethersproject/bignumber");

const provider = new ethers.providers.Web3Provider(window.ethereum)
const signer = provider.getSigner()

const SpaceContractAddr = '0x8fFe980D9777eeBAC0D69ACDc9C092014d8fE7c3'
const contract = new ethers.Contract(SpaceContractAddr, SpaceContractJSON.abi, provider);

deposit_button.addEventListener('click', async () => {
  console.log(await contract.connect(signer).deposit({value: BigNumber.from(ethers.utils.parseEther(deposit_value.value)) }));
})

// For playing around with in the browser
window.ethers = ethers
window.provider = provider
window.signer = signer
window.contract = contract


// Kick things off
go()

async function go() {
  await connectToMetamask()
}

async function connectToMetamask() {
  try {
    console.log("Signed in", await signer.getAddress())
    console.log(await contract.connect(signer).getBalanceTokens());

    balance.innerText = await contract.connect(signer).getBalanceTokens();
  }
  catch(err) {
    console.log(err)
    console.log("Not signed in")
    await provider.send("eth_requestAccounts", [])
  }

}



