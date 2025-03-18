const { ethers } = require("hardhat");

async function main() {
    
    const EWasteProcessing = await ethers.getContractFactory("EWasteProcessing");
    const eWasteProcessing = await EWasteProcessing.deploy();

    await eWasteProcessing.waitForDeployment(); 
    console.log("EWasteProcessing deployed at:", eWasteProcessing.target);

    const deviceType = "Laptop"; 
    const amountKg = 5000; 

   
    const netValueCents = await eWasteProcessing.calculateNetValueForDevice(deviceType, amountKg);
    console.log(`Net Value for ${amountKg}kg of ${deviceType}: $${(Number(netValueCents) / 100).toFixed(2)}`);

    const metals = await eWasteProcessing.getMetalsForDevice(deviceType);
    console.log(`Metals for ${deviceType}:`);

    // Log each metal name
    for (let i = 0; i < metals.length; i++) {
        console.log(metals[i]);
    }
}


main().catch((error) => {
    console.error("Error:", error);
    process.exitCode = 1;
});
