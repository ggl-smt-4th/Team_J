/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;
    address owner;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    struct Employee {
        uint salary;
        address employee;
        uint lastPayDay;
    }
    
    Employee[] employees;
    
    function addFund() payable returns (uint)  {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for(uint i=0;i<employees.length;i++){
            totalSalary = totalSalary + employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getEmployee(address addr) returns (uint salary, address employee, uint lastPayDay, uint index){
         for(uint i=0;i<employees.length;i++){
            if(employees[i].employee==addr){
                salary = employees[i].salary;
                employee = employees[i].employee;
                lastPayDay = employees[i].lastPayDay;
                index = i;
            }
        }
    }
    
   function addEmployee(address addr, uint salary){
        if(msg.sender!=owner){
            revert();
        }
        uint slr;
        address employee;
        uint lastPayDay;
        uint index;
        (slr, employee, lastPayDay, index) = getEmployee(addr);
        if(employee != 0x0){
            revert();
        }
        employees.push(Employee(salary,addr,now));
    }
    
    function updateAddress(address newAddr){
        address sender = msg.sender;
        uint slr;
        address employee;
        uint lastPayDay;
        uint index;
        (slr, employee, lastPayDay, index) = getEmployee(sender);
        if(employee == 0x0){
            revert();
        }
        employees[index].employee = newAddr;
    }
    
    function updateSalary(address addr, uint salary){
        if(msg.sender!=owner){
            revert();
        }
        uint slr;
        address employee;
        uint lastPayDay;
        uint index;
        (slr, employee, lastPayDay, index) = getEmployee(addr);
        if(employee == 0x0){
            revert();
        }
        employees[index].salary = salary;
    }
    
    function deleteEmployee(address addr){
        if(msg.sender!=owner){
            revert();
        }
        uint slr;
        address employee;
        uint lastPayDay;
        uint index;
        (slr, employee, lastPayDay, index) = getEmployee(addr);
        if(employee == 0x0){
            revert();
        }
        for(uint i = index;i < employees.length-1;i++){
            employees[index] = employees[index +1];
        }
        delete employees[employees.length-1];
        employees.length--;
        
        for(;lastPayDay+payDuration<now;){
            lastPayDay = lastPayDay+payDuration;
            employee.transfer(slr);
        }
    }
    
   function getPaid() {
        address sender = msg.sender;
        uint slr;
        address employee;
        uint lastPayDay;
        uint index;
        (slr, employee, lastPayDay, index) = getEmployee(sender);
        if(employee == 0x0){
            revert();
        }
        uint nextPayDay = lastPayDay + payDuration;
        if(nextPayDay > now){
            revert();
        }
        lastPayDay = nextPayDay;
        employee.transfer(slr);
    }
}
