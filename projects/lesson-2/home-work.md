# gas 变化的记录 

```
"0xca35b7d915458ef540ade6068dfe2f44e8fa7330", 
        
 transaction cost 	22971 gas 
 execution cost 	1699 gas 

"0xca35b7d915458ef540ade6068dfe2f44e8fa7331", 1
        
 transaction cost 	23759 gas 
 execution cost 	2487 gas 

"0xca35b7d915458ef540ade6068dfe2f44e8fa7332", 1
        
 transaction cost 	24547 gas 
 execution cost 	3275 gas 

"0xca35b7d915458ef540ade6068dfe2f44e8fa7333", 
        
 transaction cost 	25335 gas 
 execution cost 	4063 gas 

"0xca35b7d915458ef540ade6068dfe2f44e8fa7334", 1
        
 transaction cost 	26123 gas 
 execution cost 	4851 gas 

"0xca35b7d915458ef540ade6068dfe2f44e8fa7335", 1
        
 transaction cost 	26911 gas 
 execution cost 	5639 gas 

"0xca35b7d915458ef540ade6068dfe2f44e8fa7336", 
        
 transaction cost 	27699 gas 
 execution cost 	6427 gas 

"0xca35b7d915458ef540ade6068dfe2f44e8fa7337", 
        
 transaction cost 	28487 gas 
 execution cost 	7215 gas 

"0xca35b7d915458ef540ade6068dfe2f44e8fa7338", 
        
 transaction cost 	29275 gas 
 execution cost 	8003 gas 

"0xca35b7d915458ef540ade6068dfe2f44e8fa7339", 1
        
 transaction cost 	30063 gas 
 execution cost 	8791 gas 
```

# calculateRunway() 函数的优化

## 思路

calculateRunway函数每次调用都时候，employees长度都有变化并不断加长，导致gas消耗逐渐增加。

## 过程

将totalSalary 初始化定义到storage里面，每次更新employee状态时一起更改。

