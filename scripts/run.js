const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();

  // Compile our contract
  // hre (hardhat runtime environment) -- built on the fly when you run `npx hardhat` in terminal
  const GmContractFactory = await hre.ethers.getContractFactory("GmPortal");

  // Deploy our contract to our local Ethereum network -- which will be destroyed at the end
  const gmContract = await GmContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.01"),
  });

  // Wait for our contract to be mined -- Hardhat creates local miners
  await gmContract.deployed();

  // Log the address our contract was deployed to
  console.log("Contract address: ", gmContract.address);
  console.log("Contract deployed by: ", owner.address);

  // ~~~ Call the functions we created
  let gmCount;

  /*
   * Get Contract balance
   */
  let contractBalance = await hre.ethers.provider.getBalance(
    gmContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  gmCount = await gmContract.getTotalGms();
  console.log("Number of Waves: ", gmCount.toNumber());

  /** Update Testing sending a few gms with messages */
  let gmTxn = await gmContract.sayGm("gmmm");
  await gmTxn.wait();

  // Find some random addresses
  gmTxn = await gmContract.connect(randomPerson).sayGm("GM ser!");
  await gmTxn.wait();

  let allGms = await gmContract.getAllGms();
  console.log("all gms: ", allGms);

  /*
   * Get Contract balance at end to see what happened!
   */
  contractBalance = await hre.ethers.provider.getBalance(gmContract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let lastPerson = await gmContract.getLastPerson();
  console.log("last person to say gm: ", lastPerson);

  gmCount = await gmContract.getTotalGms();
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log("error: ", error);
    process.exit(1);
  }
};

runMain()