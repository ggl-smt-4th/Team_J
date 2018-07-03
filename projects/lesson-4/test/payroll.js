var Payroll = artifacts.require("Payroll");

contract('Payroll', function(accounts) {
    var testEmployeeIdx = 1;
    var testSalary = 2;
    //combine remove() and add() together
    it("should successfully addEmployee and removeEmployee", function() {
        var payroll;
        return Payroll.new().then(function(instance) {
            payroll = instance;
            return instance.addEmployee(accounts[testEmployeeIdx], testSalary, {from: accounts[0]});
        }).then(function(){
            return payroll.employees.call(accounts[testEmployeeIdx]);
        }).then(function(employee){
            assert.equal(employee[0], accounts[testEmployeeIdx], "address is new employeeAddress");
            assert.equal(employee[1], web3.toWei(testSalary), "salary is 2 ether");
        }).then(function(){
            return web3.eth.getBalance(accounts[testEmployeeIdx]).toNumber();
        }).then(function(){
            return payroll.removeEmployee(accounts[testEmployeeIdx], {from: accounts[0]});
        }).then(function() {
            return payroll.employees.call(accounts[testEmployeeIdx]);
        }).then(function(employee){
            assert.equal(employee[0], 0x0, "the address should be empty");
            assert.equals(employee[1], 0, "the salary should be 0");
        });
    });

    it("should fail addEmployee as not owner", function() {
        return Payroll.new().then(function(payroll) {
            return payroll.addEmployee(accounts[2], testSalary, {from: accounts[testEmployeeIdx]});
        }).catch(function (error) {
                assert.throws(function() {
                    throw error;
                },
                "VM exception happened");
            });
    });

    it("should fail addEmployee as employee already exists", function() {
        var payroll;
        return Payroll.new().then(function(instance) {
            payroll = instance;
            return instance.addEmployee(accounts[testEmployeeIdx], testSalary, {from: accounts[0]});
        }).then(function() {
            return payroll.addEmployee(accounts[testEmployeeIdx], testSalary, {from: accounts[0]});
        }).catch(function (error) {
            assert.throws(function() {
                    throw error;
                },
                "VM exception happened");
        });
    });

    it("should fail removeEmployee as not owner", function() {
        return Payroll.new().then(function(payroll) {
            return payroll.removeEmployee(accounts[2], {from: accounts[testEmployeeIdx]});
        }).catch(function (error) {
            assert.throws(function() {
                    throw error;
                },
                "VM exception happened");
        });
    });

    it("should fail removeEmployee as employee does not exist", function() {
        return Payroll.new().then(function(instance) {
            return instance.removeEmployee(accounts[5], {from: accounts[0]});
        }).catch(function (error) {
            assert.throws(function() {
                    throw error;
                },
                "VM exception happened");
        });
    });
    it("should fail as it is too early to get paid", function() {
        var payroll;
        return Payroll.new().then(function(instance) {
            payroll = instance;
            return instance.addEmployee(accounts[7], 2, {from: accounts[0]});
        }).then(function() {
            return payroll.getPaid({from: accounts[7]});
        }).catch(function (error) {
            assert.throws(function() {
                    throw error;
                },
                "VM exception happened");
        });
    });

    it("should fail as there is not enough fund to getPaid", function() {
        var payroll;
        var initialBalance;
        return Payroll.new().then(function(instance) {
            payroll = instance;
            return instance.addEmployee(accounts[8], 2, {from: accounts[0]});
        }).then(function() {
            return web3.eth.getBalance(accounts[8]);
        }).then(function(balance) {
            initialBalance = balance;
        }).then(function(){
            return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [11], id: 0});
        }).then(function(){
            return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
        }).then(function() {
            return payroll.getPaid({from: accounts[8]});
        }).catch(function (error) {
            assert.throws(function() {
                    throw error;
                },
                "VM exception happened");
        });
    });

    it("should successfully getPaid", function() {
        var payroll;
        var initialBalance;
        return Payroll.new().then(function(instance) {
            payroll = instance;
            return instance.addEmployee(accounts[8], 2, {from: accounts[0]});
        }).then(function() {
            return payroll.addFund({from: accounts[0], value: 30000000000000000000});
        }).then(function() {
            return web3.eth.getBalance(accounts[8]);
        }).then(function(balance) {
            initialBalance = balance;
        }).then(function(){
            return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [11], id: 0});
        }).then(function(){
            return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
        }).then(function() {
            return payroll.getPaid({from: accounts[8]});
        }).then(function() {
            return web3.eth.getBalance(accounts[8]);
        }).then(function(balance) {
            assert.isAbove(balance.toNumber(), initialBalance.toNumber(), "balance should be larger after getPaid");
        });
    });
});