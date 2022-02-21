// scripts/deploy.js
async function main () {
    // We get the contract to deploy
    const MyContract = await ethers.getContractFactory('TestPlayLearnEarnBeta');
    console.log('Deploying Contract...');
    const myContract = await MyContract.deploy();
    await myContract.deployed();
    console.log(myContract);
    console.log('Contract deployed to:', myContract.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });