pragma solidity ^0.4.14;

contract Payroll {
    uint    constant payDuration = 10 seconds;

    address owner = msg.sender; 
    uint    salary ;
    address employee;
    uint    lastPayday;
    
    function Payroll(){
        lastPayday=now;
    }
    
    function modifyEmpAddress(address _employee) {
        
        require(msg.sender == owner);
        
        if (employee != address(0)) {
            uint sparePayment = salary * (now - lastPayday) / payDuration; 
            lastPayday = now;
            employee.transfer(sparePayment);
        }
        
        employee = _employee;
    } 
    
    function modifyEmpSalary(uint _salary) payable {
        
        require(msg.sender == owner); 
        
        if (employee != address(0)) {
            uint sparePayment = salary * (now - lastPayday) / payDuration; 
            lastPayday = now;
            employee.transfer(sparePayment);
        }
        
        salary= _salary * 1 ether; 
    }
    
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        require(salary != 0);
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return  calculateRunway() > 0;
    }
    
    function getBalance () returns (uint) {
        return this.balance ;
    }
    
    function getPaid() {
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
    
    function getEmpBalance() returns (uint) {
        if(msg.sender != employee) {
            revert();
        }
        return employee.balance;
    }
}
