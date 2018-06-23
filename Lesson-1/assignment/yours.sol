/*作业请提交在这个目录下-夏建乐*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }

    function updateEmployee(address e, uint s) payable{
        //Checkout input parameter
        require(msg.sender == owner);

        // pay pervious employee before change the employee address
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
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

    function getPaid() payable{
        require(msg.sender == employee);

        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}