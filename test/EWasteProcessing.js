const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("EWasteProcessing", function () {
    let ewasteProcessing, owner;

    before(async function () {
        [owner] = await ethers.getSigners();
        const EWasteProcessingFactory = await ethers.getContractFactory("EWasteProcessing");
        ewasteProcessing = await EWasteProcessingFactory.deploy();  // No need for .deployed()
    });

    it("Should deploy and contain preloaded metals", async function () {
        const metalCount = await ewasteProcessing.getMetalsCount();
        expect(metalCount).to.be.gt(0);
    });

    it("Should add an e-waste batch", async function () {
        await ewasteProcessing.addEWasteBatch("Mobile Phone", 1500);
        const batch = await ewasteProcessing.eWasteBatches(0);

        expect(batch.deviceType).to.equal("Mobile Phone");
        expect(batch.amountKg).to.equal(1500);
    });

    it("Should calculate net value correctly", async function () {
        const netValue = await ewasteProcessing.calculateNetValueForDevice("Mobile Phone", 1500);
        console.log("Net Value in cents:", netValue.toString());

        expect(netValue).to.be.gt(0);
    });

    it("Should retrieve metals for a device type", async function () {
        const metals = await ewasteProcessing.getMetalsForDevice("Mobile Phone");
        console.log("Metals in Mobile Phone:", metals);

        expect(metals.length).to.be.gt(0);
    });
    it("Should revert if e-waste amount is zero", async function () {
        await expect(ewasteProcessing.addEWasteBatch("Laptop", 0))
            .to.be.revertedWith("Amount must be greater than zero");
    });
    it("Should return empty metals for an unknown device", async function () {
        const metals = await ewasteProcessing.getMetalsForDevice("UnknownDevice");
        expect(metals.length).to.equal(0);
    });
    it("Should revert if e-waste amount is below 1000 kg", async function () {
        await expect(ewasteProcessing.calculateNetValueForDevice("Laptop", 500))
            .to.be.revertedWith("Amount must be greater than 1000 kg");
    });
    
    
});
