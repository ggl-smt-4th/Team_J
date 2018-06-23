pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 30 days;

    address owner;
    uint salary = 1 ether;
    address employee;
    uint lastPayday;

    function updateEmployeeAddress(address newAddress) public {
        require(msg.sender == owner);
        
        if (employee != address(0)) {
            uint sparePayment = salary * (now - lastPayday) / payDuration; 
            lastPayday = now;
            employee.transfer(sparePayment);
        }
        
        employee = newAddress;
    }

    function updateEmployeeSalary(uint newSalary) public {
        require(msg.sender == owner); 
        
        if (employee != address(0)) {
            uint sparePayment = salary * (now - lastPayday) / payDuration; 
            lastPayday = now;
            employee.transfer(sparePayment);
        }
        
        salary= newSalary * 1 ether; 
    }

    function getEmployee() view public returns (address) {
        return employee;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() view public returns (uint) {
        return address(this).balance / salary;
    }

    function getSalary() view public returns (uint) {
        return salary;
    }

    function hasEnoughFund() view public returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        if(msg.sender != employee) {
            revert();
        }
        uint nextPayDay = lastPayday + payDuration;
        
        if(nextPayDay> now) {
            revert();
        }
        
        lastPayday = nextPayDay;
        employee.transfer(salary);
    }
}