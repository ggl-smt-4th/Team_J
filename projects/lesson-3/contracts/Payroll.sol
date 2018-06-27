pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 30 days;
    uint totalSalary = 0 ;
    address owner;
    mapping(address => Employee) public employees;       
    
    
    modifier employeeExist(address employeeAddress) {
        var employee = employees[employeeAddress];
        assert(employee.id != 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    
    function addEmployee(address employeeAddress, uint salary) onlyOwner {
        
        var employee = employees[employeeAddress];
        assert(employee.id == 0x0);
        totalSalary += salary * 1 ether;
        employees[employeeAddress] = Employee(employeeAddress, salary * 1 ether, now);
        
       // totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeAddress) onlyOwner employeeExist(employeeAddress) {
        
        var employee = employees[employeeAddress];
        
        
        _partialPaid(employee);
        totalSalary -= employees[employeeAddress].salary;
        
        delete employees[employeeAddress];
        
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner employeeExist(newAddress) {
        var newemployee = employees[oldAddress];
        _partialPaid(oldAddress);
        
        employees[newAddress] = Employee(newemployee.salary, now);
        delete employees[oldAddress];
    }
    
    function updateEmployee(address employeeAddress, uint salary) onlyOwner employeeExist(employeeAddress) {
       
        var employee = employees[employeeAddress];

        
        _partialPaid(employee);
       
        employees[employeeAddress].salary = salary * 1 ether;
        employees[employeeAddress].lastPayday = now;
       
    }
    
    function addFund() payable public returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public  returns (uint) {
        
		return this.balance / totalSalary;
    }
    
    function hasEnoughFund() public  returns (bool) {
        return calculateRunway() > 0;
    }
    

    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
       
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
