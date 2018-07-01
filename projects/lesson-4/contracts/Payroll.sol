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

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;
    mapping (address => Employee) public employees;

    function Payroll() payable public {
         
    }

    modifier employeeExist (address employeeId) {
        var employee =  employees[employeeId];
        assert(employee.id != 0x0);
         _;
    }

    modifier employeeNotExist (address employeeId) {
        var employee =  employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint sparePayment = employee.salary * (now - employee.lastPayday) / payDuration; 
        employee.id.transfer(sparePayment); 
    }

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) public {
        uint e = 1 ether;
        salary= SafeMath.mul(salary,e);
        employees[employeeId]=(Employee(employeeId,salary,now));
        totalSalary =SafeMath.add(totalSalary,salary); 
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public {
        var employee =  employees[employeeId];
        _partialPaid(employee); 
        totalSalary =SafeMath.sub(totalSalary,employee.salary); 
        delete employees[employeeId]; 
    }

    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner employeeExist(oldAddress) employeeNotExist(newAddress) public {
        var oldEmployee =  employees[oldAddress];
        var newEmployee =  employees[newAddress];
        employees[newAddress]=(Employee(newAddress,oldEmployee.salary,now));
        delete employees[oldAddress]; 
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner  employeeExist(employeeId) public {
        var  employee  = employees[employeeId];
       
        _partialPaid(employee); 

        totalSalary =SafeMath.sub(totalSalary,employees[employeeId].salary); 
        uint e = 1 ether;
        employees[employeeId].salary=SafeMath.mul(salary,e);
        totalSalary =SafeMath.add(totalSalary,employees[employeeId].salary); 
        employees[employeeId].lastPayday=now; 
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        assert(totalSalary > 0 );
        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender) public {
        var  employee = employees[msg.sender];
       
        uint nextPayDay = employee.lastPayday + payDuration;
        
        assert(nextPayDay < now); 
        
        employees[msg.sender].lastPayday = nextPayDay;
        employee.id.transfer(employee.salary);  
    }
    
}
