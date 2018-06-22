pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 30 days;

    address owner;
    uint salary = 1 ether;
    address employee;
    uint lastPayday;

    constructor() {
        owner = msg.sender;
    }

    function updateEmployeeAddress(address newAddress) public {
        if (!isEmployer()) revert();
        if (!isEmployeeExist()) {
            getRemainingSalary();
        }
        employee = newAddress;
        lastPayday = now;
    }

    function getRemainingSalary() private {
        uint payment = salary * (now - lastPayday) / payDuration;
        employee.transfer(payment);
    }

    function updateEmployeeSalary(uint newSalary) public {
        if (!isEmployer()) revert();
        if (isEmployeeExist()) {
            getRemainingSalary();
        }
        salary = newSalary * 1 ether;
        lastPayday = now;
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

    function isEmployeeExist() private returns (bool){
        return employee != 0x0;
    }

    function isEmployer() private returns (bool) {
        return owner == msg.sender;
    }

    function getPaid() public {
        if (!isEmployeeExist() || msg.sender != employee) {
            revert();
        }
        uint nextPayDay = lastPayday + payDuration;
        if (nextPayDay > now) {
            revert();
        }
        lastPayday = now;
        employee.transfer(salary);
    }
}