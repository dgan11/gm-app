// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// Use hardhat to get console.logs easitly
import "hardhat/console.sol";

contract GmPortal {
  uint256 gmCounter; // state variable stored on chain
  address lastPerson;
  uint256 private seed;

  /**
  * Define a Solidity event:
  *  - An event is emitted, it stores the arguments passed in transaction logs
  *  - These logs are stored on chain and are acessible 
  */
  event NewGm(address indexed from, uint256 timestamp, string message);

  /** Create a struct here named GM */
  struct GM {
    address gmer; // the address of the user who said gm
    string message; // the message the user sent
    uint256 timestamp; // The timestamp when the user waved
  }

  // Declare a variable waves that lets me store an array of structs
  GM[] gms;

  // address => uint mappin to associate an address with the last time they waved
  mapping(address => uint256) public lastTimeWalletSaidGm;

  constructor() payable { // payable allows the contract to be able to pay people
    console.log("GM CONTRACT CONSTRUCTOR");
  }

  // Function so someone can wave at you
  function sayGm(string memory _message) public {

    // Make sure the current timestamp is 15 minutes later than last
    require(
      lastTimeWalletSaidGm[msg.sender] + 5 seconds < block.timestamp,
      "Wait 5 seconds to cool down"
    );

    // Update the current timestamp for the user
    lastTimeWalletSaidGm[msg.sender] = block.timestamp;

    gmCounter += 1;
    lastPerson = msg.sender;
    console.log("%s has said gm: ", msg.sender, " with message: ", _message);

    // Store the gm data in the array
    gms.push(GM(msg.sender, _message, block.timestamp));

    // Generate a psuedo random number between 0 & 100
    uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;
    console.log("Random # generated: %s", randomNumber);

    seed = randomNumber;

    if (randomNumber < 50) {
      console.log("%s won!", msg.sender);
      // Send everyone who sends us a gm 0.0001 ETH
      uint256 prizeAmount = 0.0001 ether;
      require( // check if some condition is true, if false quit the function and cancel the transaction
        prizeAmount <= address(this).balance, "Trying to withdraw more money than this contract has"
      );
      (bool success, ) = (msg.sender).call{value: prizeAmount}(""); // send the money
      require(success, "Failed to withdraw money from contract.");  
    }

    // Emit the event
    emit NewGm(msg.sender, block.timestamp, _message);
  }

  // Get the total number of waves
  function getTotalGms() public view returns (uint256) {
    console.log("We have %d total gm's: ", gmCounter);
    return gmCounter;
  }

  // Get the last person that said gm
  function getLastPerson() public view returns (address) {
    console.log("most recent person to say gm: ", lastPerson);
    return lastPerson;
  }

  /** Added a function to getAllGms which will return the struct array */
  function getAllGms() public view returns (GM[] memory) {
    return gms;
  }

}

