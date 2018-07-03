let Payroll = artifacts.require("./Payroll.sol");

contract("Payroll",(accounts) => {
    const owner = accounts[0];
    const employee = accounts[3];
    const guest = accounts[2];
    const salary = 1;

    let payroll;

  beforeEach("Setup contract for each test cases", () => {
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    });
  });

    it("test call removeEmployee() by owner",() =>{
        return payroll.removeEmployee(employee,{from : owner});
    });

    it("Test call removeEmployee() by guest", () => {
        return payroll.removeEmployee(employee, {from: guest}).then(() => {
          assert(false, "Should not be successful");
        }).catch(error => {
          assert.include(error.toString(), "Error: VM Exception", "Cannot call removeEmployee() by guest");
        });
      });

    it("test call removeEmployee() not exist employee by owner",() =>{
        return payroll.removeEmployee(guest,{from : owner}).then(() => {
            assert(false,"should not be successful");
        }).catch(error => {
            assert.include(error.toString(),"Error:VM Exception","cannot call removeEmployee  not exist employee by employee")
        });
    });

    it("test call removeEmployee() by employee",() =>{
        return payroll.removeEmployee(employee,{from : employee}).then(() => {
            assert(false,"should not be successful");
        }).catch(error => {
            assert.include(error.toString(),"Error:VM Exception","cannot call removeEmployee by employee")
        });
    });
  
});
