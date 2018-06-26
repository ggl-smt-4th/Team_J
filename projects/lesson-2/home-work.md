
transacations cost ||  execution cost
22974                   1702
23755                   2483
24536                   3264
25317                   4045
26098                   4826
26879                   5607
27660                   6388
28441                   7169
29222                   7950
30003                   8731

gas的变化是因为每次加入一个新的员工，调用calculateRunaway（）时候就需要
计算一次所有的employee的salary之和，这样每次增加一个，gas的cost就会增加，
因为计算量比上次多了一个employee的salary。

改进方法：

可以在contract维护着一个全局变量：uint totalsalary。

然后在每次调用add employee的时候，需要更新totalslary += salary；

同时对于partialpayment这个方法，也需要对totalsalary进行改变，因为此时
salary不再有效，所以需要totalsalary -= employee.salary;

然后对于updateEmployee这个方法，还需要再加上新的salary。 
totalSalary += salary;

这样的话调用calculateRunaway（）的gas cost就不会再发生变化，因为此时的totalsalary
的值是恒定的。