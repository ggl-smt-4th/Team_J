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
                break;
            }
        }
    }
    
   function addEmployee(address addr, uint salary){
        if(msg.sender!=owner){
            revert();
        }
        address employee;
        (, employee, , ) = getEmployee(addr);
        if(employee != 0x0){
            revert();
        }
        employees.push(Employee(salary * 1 ether,addr,now));
    }
    
    function updateAddress(address newAddr){
        address sender = msg.sender;
        address employee;
        uint index;
        (, employee, , index) = getEmployee(sender);
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
        
        uint totalSalary = (now - lastPayDay) / payDuration * slr;
        employees[index].lastPayDay = now;
        employees[index].salary = salary * 1 ether;
        employee.transfer(totalSalary);
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
        employees[index] =  employees[employees.length-1];
        delete employees[employees.length-1];
        employees.length--;
        
        uint totalSalary = (now - lastPayDay) / payDuration * slr;
        employee.transfer(totalSalary);
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
