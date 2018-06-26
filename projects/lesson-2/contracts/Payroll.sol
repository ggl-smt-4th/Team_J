pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        // TODO: your code here
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;

    address owner;
    mapping(address => Employee) employees;
    uint totalSalary;

    function Payroll() payable public {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        var employee = employees[employeeAddress];
        assert(employee.id == 0x0);
        totalSalary += salary * 1 ether;
        employees[employeeAddress] = Employee(employeeAddress,salary * 1 ether, now);
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        // TODO: your code here
        var employee = employees[employeeId];
        assert(employee.id != 0x0);

        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        var employee = employees[employeeAddress];
        assert(employee.id != 0x0);

        _partialPaid(employee);
        totalSalary -= employees[employeeAddress].salary;
        employees[employeeAddress].salary = salary * 1 ether;
        totalSalary += employees[employeeAddress].salary;
        employees[employeeAddress].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        var employee = employees[msg.sender];
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}

