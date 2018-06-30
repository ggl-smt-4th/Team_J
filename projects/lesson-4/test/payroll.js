var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

//addEmployee

	it('Testing addEmployee function by owner', function() {
		return Payroll.deployed().then(function(instance) {
			payrollInstance = instance;

			return payrollInstance.addEmployee(accounts[1], 1， {from: accounts[0]});
		});

	}).then(function() {
		return payrollInstance.get.call(accounts[1]);

	}).then(function(employee) {
		assert.equal(employee[1].toNumber(), 1, "salary is incorrect.")
	});

	it('Testing addEmployee function by non-owner', function() {
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.addEmployee(accounts[2], 1, {from: accounts[0]})
		});
	}).then(function() {
		return payrollInstance.get.call(accounts[2]);
	}).then(function(employee) {
		assert.equal(true, 1, "non-owner operation error.")
	})


//removeEmployee

	it("Testing removeEmployee function", function() {
		return Payroll.deployed().then(function(instance) {
			payrollInstance = instance;

			return payrollInstance.removeEmployee(accounts[3], 1, {from: accounts[0]})
		}).then(function() {
			return payrollInstance.get.call(accounts[3]);
		}).then(function(employee) {
			assert.equal(true, 1, "Removing employee error.");
		}) 
	})
});
