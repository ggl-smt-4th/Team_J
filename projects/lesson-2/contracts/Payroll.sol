pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint totalSalary;
    
    address owner;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
    }

   function _findEmployee(address id) private returns (Employee ,uint){
        for(uint i=0;i<employees.length;i++){
            if(employees[i].id == id){
                return (employees[i],i);
            }
        }
        return (Employee(0,0,0), 0);
    }
    
    //计算该员工目前需要支付多少薪水
    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        
       var(employee,index) = _findEmployee(employeeAddress);
        assert(employee.id == 0x0);
        
        salary = salary * 1 ether;
        totalSalary +=salary;
        employees.push(Employee(employeeAddress,salary,now));
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
       
        var(employee,index) = _findEmployee(employeeId);
         assert(employee.id != 0x0);
         
        _partialPaid(employees[index]);
        totalSalary -= employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        
         var(employee,index) = _findEmployee(employeeAddress);
        assert(employee.id != 0x0);
        
         _partialPaid(employees[index]);
         totalSalary = totalSalary - employees[index].salary + (salary * 1 ether);
         employees[index].salary = salary;
         employees[index].lastPayday = now;
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

    function getPaid() public {
        var(employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPay = employee.lastPayday + payDuration;
        assert(nextPay < now);
        
        employees[index].lastPayday = nextPay;
        employees[index].id.transfer(employee.salary);
    }
}

