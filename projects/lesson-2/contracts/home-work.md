#### gas变化的记录

|            | transaction cost(gas) | execution cost(gas) | 增量(gas) |
| ---------- | --------------------- | ------------------- | --------- |
| 第1次调用  | 23001                 | 1729                | 781       |
| 第2次调用  | 23782                 | 2510                | 781       |
| 第3次调用  | 24563                 | 3291                | 781       |
| 第4次调用  | 25344                 | 4072                | 781       |
| 第5次调用  | 26125                 | 4853                | 781       |
| 第6次调用  | 26906                 | 5634                | 781       |
| 第7次调用  | 27687                 | 6415                | 781       |
| 第8次调用  | 28468                 | 7196                | 781       |
| 第9次调用  | 29249                 | 7977                | 781       |
| 第10次调用 | 30030                 | 8758                | 781       |





#### gas变化的原因

每次加入一个员工后调用 `calculateRunway()` 这个函数后，其消耗的gas都会增加，并且是有序增加。gas增加的原因是，每增加一个员工，在计算totalSalary时，就需要多遍历一次员工的salary.



#### `calculateRunway()`函数优化

优化的方式是，将totalSalary设置为全局变量，在每次添加、删除和修改员工信息时，更新totalSalary值。这样避免了每次调用该方法时，都需要遍历一遍员工信息。
` Payroll `合约中，增加 ` uint totalSalary;`
` addEmployee() `增加 `totalSalary += salary * 1 ether`
`removeEmployee`增加`totalSalary -= employees[index].salary;`
`updateEmployee`增加` totalSalary = totalSalary + (salary*1 ether)  - employees[index].salary;`

这样改造后，可以确保每次调用calculateRunway()消耗的gas是相同的，但是不足是，在增加、修改和删除员工时，gas消耗变多。

