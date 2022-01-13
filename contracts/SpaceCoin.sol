//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SpaceCoin is ERC20 {

  address private immutable TREASURY_ACC;
  address private immutable ICO_ADDRESS; 

  uint256 private constant MAX_SUPPLY = 500000;
  uint256 private constant TAX_PERC = 2;

  address private immutable OWNER_ADDRESS;

  bool private useTax = false;

  constructor(address _treasuryAddr) ERC20("SpaceCoin", "SPC") {

    TREASURY_ACC  = _treasuryAddr;
    OWNER_ADDRESS = msg.sender;

    _mint(_icoAddress, MAX_SUPPLY * (10 ** decimals()));

  }

  function setTax(bool _active) public {
    
    require(msg.sender == OWNER_ADDRESS);

    useTax = _active;
  }

  function _transfer(address sender, address _recipient, uint256 _amount) internal override {

    console.log("AMOUNT TO TRANSFER", _amount);        
    console.log("        INVES     ", msg.sender);
    console.log("        SENDER     ", sender);

    if(useTax) {
      uint256 taxFee = (_amount * TAX_PERC) / 100;
      
      _amount -= taxFee;

      super._transfer(sender, TREASURY_ACC, taxFee);
    }

    console.log("BALANCE INVEST     ", balanceOf(sender));

    super._transfer(sender, _recipient, _amount);

    console.log("BALANCO RECIP      ", balanceOf(_recipient));
    console.log("BALANCO FINAL      ", balanceOf(sender));

  }      



}