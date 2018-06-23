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
    
    function _findEmployee(address id) private returns (Employee storage,uint){
        for(uint i=0;i<employees.length;i++){
            if(employees[i].id == id){
                return (employees[i],i);
            }
        }
    }
    
    //计算该员工目前需要支付多少薪水
    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    

    function Payroll() payable public {
        owner = msg.sender;
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        
       var(employee,index) = _findEmployee(employeeAddress);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeAddress,salary * 1 ether,now));
        
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
       
        var(employee,index) = _findEmployee(employeeId);
         assert(employee.id != 0x0);
        _partialPaid(employees[index]);
        delete(employees[index]);
        employees[index] = employees[employees.length-1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        
         var(employee,index) = _findEmployee(employeeAddress);
        assert(employee.id != 0x0);
         _partialPaid(employees[index]);
         employees[index].salary = salary;
         employees[index].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        uint totalSalary;
        for(uint i =0;i<employees.length;i++){
            totalSalary += employees[i].salary; 
        }
        return addFund() / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        //require(hasEnoughFund()==true);
        var(employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPay = employee.lastPayday + payDuration;
        assert(nextPay < now);
        employees[index].lastPayday = nextPay;
        employee.id.transfer(employee.salary);
        
    }
}

