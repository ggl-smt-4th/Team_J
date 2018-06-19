pragma solidity ^0.4.14;
contract paoyroll{
    uint salary;
    address frank ;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    function getAddress(address name) returns (address)
    {
        return frank=name;
    }
    function setMoney(uint money) returns (uint){
       return salary=money  * 1 ether;
    }
    function addfund() payable returns(uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
        return this.balance/salary;
    }
    
    function hasEnoughFund() returns (bool)
    {
        return calculateRunway() > 0;
    }
    
    function getpaid(){
        if(msg.sender != frank)
        {
            revert();
        }
        uint nextPayday= lastPayday + payDuration;
        if(nextPayday > now)
        {
            revert();
        }
        lastPayday=nextPayday;
        frank.transfer(salary); 
    }
 }
