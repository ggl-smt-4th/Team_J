pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 30 days; // set to 30 days so that we don't owe previous employee too much :-P

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }

    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);

        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        // adding this check, otherwise calculateRunway throws if salary==0
        if (s == 0){
            revert();
        }
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }

    function updateEmployeeAddress(address e) {
        updateEmployee(e, salary);
    }
    function updateSalary(uint s) {
        updateEmployee(employee, s);
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

    function getPaid() {
        require(msg.sender == employee);

        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
