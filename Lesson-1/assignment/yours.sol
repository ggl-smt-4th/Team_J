pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
        salary = 1 ether;
        lastPayday = now;
        employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    }

    /*
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);

        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }
    */

    //清算工资
    function payoff() returns (bool) {
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            require (payment < this.balance);
            employee.transfer(payment);
        }

        lastPayday = now;
        return true;
    }

    //更改员工地址
    function updateEmployee(address e) {
        require(msg.sender == owner);
        if (payoff()) {
            employee = e;
        }
    }

    //更改员工薪水
    function updateSalary(uint s) {
        require(msg.sender == owner);
        if (payoff()) {
            salary = s * 1 ether;
        }
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
