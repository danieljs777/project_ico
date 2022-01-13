//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./SpaceCoin.sol";

contract SpaceICO
{

  enum Phase
  {
    Seed,
    General,
    Open
  }

  bool private active = true;
  Phase private phase = Phase.Seed;

  uint256 private constant GOAL_AMOUNT = 30000 ether;
  uint256 private constant MAX_PRIV_IND_CONTRIB = 1500 ether;
  uint256 private constant MAX_PRIV_TOTAL_CONTRIB = 15000 ether;
  uint256 private constant MAX_GEN_IND_CONTRIB = 1000 ether;

  address private immutable OWNER_ADDRESS;
  SpaceCoin private SPACE_COIN;

  uint256 private constant EXCHANGE_RATE = 5;

  mapping(address => uint256) private investments;

  mapping(address => bool) private whitelisted;

  modifier onlyOwner() {
    require(msg.sender == OWNER_ADDRESS);
    _;
  }

  constructor() {

    OWNER_ADDRESS = msg.sender;
    
    whitelisted[msg.sender] = true;

  }

  function setSpaceCoin(SpaceCoin _space_coin) external onlyOwner {
    
    require(address(SPACE_COIN) == address(0), "WRITE_ONCE");
    SPACE_COIN = _space_coin;

  }

  function addWhitelist(address newInvestor) external onlyOwner {
    whitelisted[newInvestor] = true;
  }

  function removeWhitelist(address newInvestor) external onlyOwner {
    whitelisted[newInvestor] = false;
  }

  function setActive(bool _active) external onlyOwner {
    active = _active;
  }

  function stepPhase(Phase _phase) external onlyOwner {

    require(phase == _phase, "Phase given is not the current Phase");
    
    if(phase == Phase.Seed) {
        phase = Phase.General;
    } else if(phase == Phase.General) {
        phase = Phase.Open;
    }

  }

  function deposit() external payable {

    uint256 _amount = msg.value;
    console.log("================================");
    console.log("        INVES     ", msg.sender);

    require(active == true, "INACTIVE_ICO");
    require(address(this).balance < GOAL_AMOUNT, "OVER_GOAL");

    console.log("AMOUNT TO DEPOSIT", _amount);
    console.log("CURRENT BALANCE :", address(this).balance);

    if(phase == Phase.Seed) {
      require(whitelisted[msg.sender] != false, "NOT_IN_WHITELIST");
      require(investments[msg.sender] + _amount <= MAX_PRIV_IND_CONTRIB, "OVER_INDIVIDUAL_PRIVATE_LIMIT");
      require(investments[msg.sender] + address(this).balance <= MAX_PRIV_TOTAL_CONTRIB, "OVER_TOTAL_PRIVATE_CONTRIB");
    }

    if(phase == Phase.General) {
      require(investments[msg.sender] + msg.value <= MAX_GEN_IND_CONTRIB, "OVER_TOTAL_OPEN_CONTRIB");
    }

    investments[msg.sender] += _amount;

    if(phase == Phase.Open) {
      redeem();
    }

  }

  function redeem() public {

    require(phase == Phase.Open, "ICO is not opened");

    uint256 amount = investments[msg.sender] * EXCHANGE_RATE;

    investments[msg.sender] = 0;

    (bool success) = SPACE_COIN.transfer(msg.sender, amount);
    require(success, "Redeem Failed");

  }    

  // function withdraw(address _recipient) external onlyOwner {

  //   require(address(_recipient) != address(0x0), "Zero check on recipient");

  //   (bool success, ) = payable(_recipient).call{ value: address(this).balance }("");
  //   require(success, "withdraw Failed");

  // }


}

