//: Playground - noun: a place where people can play

import UIKit


let b = 10
var a = 5
a = b                                // a为10,"="的意思:把b的值赋值给a

let (x, y) = (1, 4)                  // 左右边都是一个多元组,那么会被自动分解多个常量变量
print(x)                             // 1, x为常量
print(y)                             // 4, y为常量


// 算术运算符 + - * /
1 + 1                                // 2
3 - 1                                // 2
1 * 2                                // 2
6 / 3                                // 2

print("Hello"+"World")               // HelloWorld 可以用+进行字符串拼接

7 % 3                                // 1 求余运算
-11 % 3                              // -2  11前的符号能被保留
11 % -3                              // 2   3的符号会被忽略,与上面-11 % 3的取余不一样

a += 2                               // 等价于 a = a + 2

// 常见的比较运算符 == != > < >= <=
3 == 4                               // false
3 != 4                               // true
3 > 4                                // false
3 < 4                                // true
3 >= 4                               // false
3 <= 4                               // true


let c = a == 2 ? 7 : 8              // 三目运算符:如果a==2为true,那么c为7,否则为8


let optionalE: Int? = 4
let d = optionalE ?? b              // 空合运算符:如果optionalE为nil,d为b的值,如果不为空就是optionalE解包后的值

1...5                               // 定义一个1到5的数,包含1和5
1..<5                               // 定义一个1到5的数,只包含1

// 逻辑非 !a 逻辑与 a&&b 逻辑或 a||b
!true                               // false
true && true                        // true
false || false                      // false

