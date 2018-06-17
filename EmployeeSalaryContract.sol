pragma solidity ^0.4.14;

contract EmployeeSalaryContract {
    uint salary = 1 ether;
    uint constant payDuration = 2 seconds;
    uint lastPayDay = now; //when the contract is created
    address employee; // default value is 0x0
    address employer; // add employer since employer will manage update employee address and salary

    constructor() {
        employer = msg.sender; //whoever created this contract will be employer
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        if (!employeeExist() || !isEmployee()) revert();


        uint nextPayDay = lastPayDay + payDuration;
        // make sure current time is the time to get paid
        if (nextPayDay > now) {
            revert();
        }
        //update lastPayDay and transfer the salary
        lastPayDay = nextPayDay;
        employee.transfer(salary);
    }

    function updateEmployeeAddress(address newAddr) {
        if (!isEmployer()) {
            revert();
        }
        //if there is still balance remaining for previous employee
        if (this.balance > 0) {
            employee.transfer(this.balance);
        }
        employee = newAddr;
        lastPayDay = now;
    }

    function updateSalary(uint newSalary) {
        //make sure employee exist
        if (!isEmployer() || !employeeExist()) {
            revert();
        }
        salary = newSalary;
    }

    function isEmployee() private returns (bool) {
        return employee == msg.sender;
    }

    function employeeExist() private returns (bool) {
        return employee != 0x0;
    }

    function isEmployer() private returns (bool) {
        return employer == msg.sender;
    }
}