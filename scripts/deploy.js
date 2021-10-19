const main = async () => {
  const [deployer] = await hre.ethers.getSigners();
  const accountBalance = await deployer.getBalance();

  console.log("Deploying contracts with account: ", deployer.address);
  console.log("Account balance: ", accountBalance.toString());

  // Deploy the contract
  const gmContractFactory = await hre.ethers.getContractFactory("GmPortal"); // compile
  const gmContract = await gmContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.001"),
  });                           // deploy
  await gmContract.deployed();                                       // make sure its mined

  console.log("GmPortal address: ", gmContract.address);

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  }
  catch (error) {
    console.error(error);
    process.exit(1);
  }
}

runMain();