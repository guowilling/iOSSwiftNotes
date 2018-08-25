//: Playground - noun: a place where people can play

import UIKit



// 变量与常量
let constantString: String = "Hello"       // let 常量名称: 字符串类型 = "字符串"
var varibleString: String = "World"        // var 变量名称: 字符串类型 = "字符串"

let constantInt: Int = 1                   // 常见的类型有 Int Double String Bool
var pi = 3.14                              // pi是Double类型

//constantInt = 2                          // ❌,constantInt是一个常量
pi = 3.1415926                             // ✅

print(constantInt)                         // 1
print("π的值是:\(pi)")                      // 输出:3.1415926.输出字符串时将常量或变量放入\()


let three = 3                             // 按住option,鼠标移动到变量名上,点击可以查看常量类型
var pointOneFour = 0.14                   // 系统自动推断pointOneFour的类型为:Double
pi = Double(three) + pointOneFour         // 只有类型一直才能操作,转换格式: 类型名(变量或常量)
let piInt = Int(pi)                       // Double转Int,系统自动忽略小数点后面的数,会损失精度

let trueValue = true                      // Bool两种类型: true false
let falseValue = false                    // 在循环,选择语句(比如if语句)的条件判断中只能使用Bool值

let i = 1
//if i {
    // 会报错,i不是bool类型
//}
if i==1 {
    print(i==1)                           // true
    // i==1是一个Bool值返回true
}

let http404Error = (404, "Not Found")     // 类型为:(Int, String),元组中的元素类型可以不同
let (code, message) = http404Error        // 将元组赋值给一个常量
print("code:\(code), message:\(message)") // code:404, message:Not Found
let (_, ErrorMessage) = http404Error      // _ 可以起到省略的作用,这个在swift中应用很广泛
print(http404Error.1)                     // Not Found 通过下标访问元素
let ErrorCode = (requestError:401, 402, 403)    // 定义元组的时候可以给单个元素命名



