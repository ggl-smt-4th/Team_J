pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address id;
        uint salary; 
        uint lastPayday;
    }

    uint constant payDuration = 30 days;

    address owner;
    Employee[] employees;
    uint totalSalary;
    bool employChanged; 

    function Payroll() payable public {
        owner = msg.sender;
    }

    function _findEmployee(address employeeId) private returns ( Employee ,uint) { 
        for (uint i =0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i],i);
            }
        }
    }

    function _partialPaid(Employee employee) private {
        uint sparePayment = employee.salary * (now - employee.lastPayday) / payDuration; 
        employee.id.transfer(sparePayment); 
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeAddress);
     
        assert(employee.id == 0x0);
        salary = salary * 1 ether;
        employees.push(Employee(employeeAddress,salary,now));
        employChanged = true;
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        
        assert(employee.id != 0x0);
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -= 1; 
        employChanged = true;
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeAddress);
        assert(employee.id != 0x0);
         
        _partialPaid(employee); 
        salary= salary * 1 ether;
        employees[index].salary=salary;  
        employees[index].lastPayday=now; 
        employChanged =true;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        if(employChanged){
            totalSalary=0;
            for(uint i=0; i<employees.length; i++) {
                totalSalary +=employees[i].salary;
            }
            employChanged = false;
        }
        
        assert(totalSalary > 0 );
        
        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var (employee,index) = _findEmployee(msg.sender);
        assert(employee.id !=0x0);
                
        uint nextPayDay = employee.lastPayday + payDuration;
        
        assert(nextPayDay < now); 
        
        employees[index].lastPayday = nextPayDay;
        employees[index].id.transfer(employee.salary); 
       
    }
}

