-  ##### 优化前calculateRunway execution cost gas 消耗情况

员工数量 | calculateRunway() execution cost
---|---
 1  |1746 gas
2| 2527 gas
3|3308 gas
4|4089 gas
5|4870 gas
6|5651 gas
7|6432 gas
8|7213 gas
9|7994  gas
10|8775  gas

- 结论：calculateRunway()，随着员工数量增加，gas花费不断在增长；

```
// 原智能代码片段
function calculateRunway() returns (uint) {
    uint totalSalary=0;
    for(uint i=0; i<employees.length; i++) {
            totalSalary +=employees[i].salary;
    }
    return this.balance / totalSalary;
}
```
- ##### gas变化原因说明：
    - 员工数量每多增加一个，calculateRunway函数，for循环次数多增加一次，即累加工资累计计算次数也多增加一次。gas费用随着员工数量的增长而增长。
    - 因totalSalary是函数内局部变量，每次调用该函数是，不管员工数量是否增加/减少，都会重新计算员工总工资，会造成员工数量不变的情况下的多余重复计算。
  

- ##### 智能合约代码优化如下：
    - 1、设置totalSalary为全局合约状态变量。
    - 2、在addEmployee()、removeEmployee()、updateEmployee()函数中对totalSalary根据场景进行变化。
    - 3、calculateRunway，用address(this).balance / totalSalary，每次gas消耗一样。