pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    mapping (address => Employee) employees;

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;

    modifier employeeExit(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x00);
        _;
    }

    function Payroll() payable public {
        // TODO: your code here
    }

        //清算工资
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary
                .mul(now - employee.lastPayday)
                .div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner public {
        var employee = employees[employeeId];
        assert(employee.id == 0x00);

        salary = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId,salary,now);
        totalSalary += salary;
    }

    function removeEmployee(address employeeId) onlyOwner employeeExit(employeeId) public {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner public {
        var employee = employees[oldAddress];
        _partialPaid(employee);
        employees[newAddress] = Employee(newAddress, employee.salary, now);
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExit(employeeId) public {
        var employee = employees[employeeId];

        salary = salary.mul(1 ether);
        _partialPaid(employee);

        totalSalary = totalSalary.sub(employee.salary);
        employees[employeeId].salary = salary;
        employees[employeeId].lastPayday = now;
        totalSalary = totalSalary.add(employee.salary);
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExit(msg.sender) public {
        var employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
