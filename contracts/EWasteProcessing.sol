// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EWasteProcessing {
    struct Metal {
        string name;
        string deviceType;
        uint256 contentMgPerKg;
        uint256 recoveryEfficiencyPercent;
        uint256 marketPriceCentsPerMg;
        uint256 recoveryCostPercent;
    }

    struct EWasteBatch {
        string deviceType;
        uint256 amountKg;
    }

    Metal[] public metals;
    EWasteBatch[] public eWasteBatches;
    
    event MetalAdded(string deviceType, string name, uint256 contentMgPerKg, uint256 marketPriceCentsPerMg);
    event EWasteBatchAdded(string deviceType, uint256 amountKg);

    constructor() {
        addMetal("Mobile Phone", "Gold", 300, 95, 8475000, 8);
        addMetal("Mobile Phone", "Silver", 1000, 90, 96300, 8);
        addMetal("Mobile Phone", "Copper", 150000, 85, 907, 20);
        addMetal("Mobile Phone", "Palladium", 20, 90, 2880000, 8);
        addMetal("Mobile Phone", "Aluminium", 40000, 85, 249, 20);
        addMetal("Mobile Phone", "Iron", 200000, 90, 10, 20);
        addMetal("Mobile Phone", "Nickel", 5000, 80, 1521, 20);
        addMetal("Mobile Phone", "Zinc", 3000, 80, 290, 20);
        addMetal("Mobile Phone", "Lead", 2000, 75, 194, 20);
        addMetal("Mobile Phone", "Tin", 1000, 70, 2994, 20);
        
        addMetal("Laptop", "Gold", 90, 63, 8475000, 8);
        addMetal("Laptop", "Silver", 200, 63, 96300, 8);
        addMetal("Laptop", "Copper", 68500, 85, 907, 20);
        addMetal("Laptop", "Palladium", 50, 63, 2880000, 8);
        addMetal("Laptop", "Aluminium", 84400, 75, 249, 20);
        addMetal("Laptop", "Iron", 142000, 86, 10, 20);
        addMetal("Laptop", "Nickel", 25000, 90, 1521, 20);
        addMetal("Laptop", "Zinc", 4000, 90, 290, 20);
        addMetal("Laptop", "Lead", 5000, 90, 194, 20);
        addMetal("Laptop", "Tin", 8000, 90, 2994, 20);
        addMetal("Laptop", "Cobalt", 20000, 90, 1521, 20);
        addMetal("Laptop", "Chromium", 2000, 90, 1521, 20);
        addMetal("Laptop", "Magnesium", 10000, 90, 249, 20);
    }

    function addMetal(
        string memory _deviceType,
        string memory _name, 
        uint256 _contentMgPerKg, 
        uint256 _recoveryEfficiencyPercent, 
        uint256 _marketPriceCentsPerMg, 
        uint256 _recoveryCostPercent
    ) public {
        metals.push(Metal(
            _name, 
            _deviceType,
            _contentMgPerKg, 
            _recoveryEfficiencyPercent, 
            _marketPriceCentsPerMg, 
            _recoveryCostPercent
        ));
        emit MetalAdded(_deviceType, _name, _contentMgPerKg, _marketPriceCentsPerMg);
    }

    function addEWasteBatch(string memory _deviceType, uint256 _amountKg) public {
        require(_amountKg > 0, "Amount must be greater than zero");
        eWasteBatches.push(EWasteBatch(_deviceType, _amountKg));
        emit EWasteBatchAdded(_deviceType, _amountKg);
    }

    function calculateNetValueForDevice(string memory _deviceType, uint256 _amountKg) 
        public 
        view 
        returns (uint256 totalNetValueCents) 
    {
        require(_amountKg > 1000, "Amount must be greater than zero");
        totalNetValueCents = 0;

        for (uint256 i = 0; i < metals.length; i++) {
            Metal memory metal = metals[i];
            if (keccak256(bytes(metal.deviceType)) == keccak256(bytes(_deviceType))) {
                uint256 recoverableMg = (_amountKg * metal.contentMgPerKg * metal.recoveryEfficiencyPercent) / 100;
                uint256 metalValueCents = recoverableMg * metal.marketPriceCentsPerMg;
                uint256 recoveryCostCents = (metalValueCents * metal.recoveryCostPercent) / 100;
                totalNetValueCents += (metalValueCents - recoveryCostCents);
            }
        }
        return totalNetValueCents;
    }
    function getMetalsForDevice(string memory _deviceType) 
    public 
    view 
    returns (string[] memory metalNames) 
{
    uint256 metalCount = 0;

    
    for (uint256 i = 0; i < metals.length; i++) {
        Metal memory metal = metals[i];
        if (keccak256(bytes(metal.deviceType)) == keccak256(bytes(_deviceType))) {
            metalCount++;
        }
    }

   
    metalNames = new string[](metalCount);
    uint256 index = 0;

   
    for (uint256 i = 0; i < metals.length; i++) {
        Metal memory metal = metals[i];
        if (keccak256(bytes(metal.deviceType)) == keccak256(bytes(_deviceType))) {
            metalNames[index] = metal.name;
            index++;
        }
    }

    return metalNames;
}
function getMetalsCount() public view returns (uint256) {
    return metals.length;
}

    
}