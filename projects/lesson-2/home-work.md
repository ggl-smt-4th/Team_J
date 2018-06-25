#### 1.每次加入一个员工后调用 `calculateRunway()` 这个函数，并且记录消耗的 gas。Gas 变化么？如果有，为什么？
`calculateRunway()` gas 消耗如下：
|员工数         |  transaction cost           | execution cost  |
| ------------- |:-------------:| -----:|
|1 | 22974| 1702 |
|2 | 23755| 2483 |
|3 | 24536| 3264 |
|4 | 25317| 4045 |
|5 | 26098| 4826 |
|6 | 26879| 5607 |
|7 | 27660| 6388 |
|8 | 28441| 7169 |
|9 | 29222| 7950 |
|10 | 30003| 8731| 

改进前`calculateRunway()`采用的是遍历所有员工，依次相加其工资，算法复杂度是O(n）。因为智能合约的gas消耗和运算量相关，从记录可以看出，gas是线性增长的，cost每次增加781。

#### 2.`calculateRunway()` 函数的优化思路和过程
增加一个变量`uint totalSalary`,用于记录员工的总工资，在更新员工工资、添加员工、删除员工时进行记录。
```
totalSalary = totalSalary - employee.salary + salary;
totalSalary = totalSalary - employee.salary;
totalSalary += salary;
```
每次`calculateRunway()`进行计算时，调取员工总工资的记录，进行乘法运算，算法复杂度为O(1)。消耗为transaction cost ： 22132,execution cost ：860，不再随员工数量的增加而增加。