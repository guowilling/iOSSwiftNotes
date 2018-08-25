//: Playground - noun: a place where people can play

import UIKit

// For-In 循环
for num in 1...5 {                    // 依次把闭区间[1, 5]中的值赋值给num
    print(num)                        // 依次输出5个数字
}

for _ in 1...5 {                      // _ 替代变量名
    print("A")                        // 依次输出5个字符串"A"
}

let chars = ["A", "B", "C", "D"]
for char in chars {
    print(char)                       // 依次输出字典中每个元素
}

let charDict = ["0":"A", "1":"B", "2":"C"]
for (key, value) in charDict {        // 遍历字典
    print("key:\(key),value:\(value)") // 依次输出字典中key:0,value:A对应的值
}

// while循环
var num = 3
while num > 0{                         // 当num > 0为true执行后面的{},否则跳过{}
    print(num)                         // 输出 3  2  1
    num = num - 1                      // 每次循环 num - 1
}

// repeat-While循环,和while循环差不多
num = 3
repeat {                               // 第一次即使条件不满足也会进入{}
    print(num)                         // 3
    num = num - 1                      // 每次循环 num - 1
}while num < 0

// if条件语句
num = 3
if num == 3 {                         // if后判断语句返回为真,执行后面{}
    print(num)                        // if语句后面的{}不能省略
}else {                               // if后判断语句返回为假,执行else后面{}
    print("num is not equeal to 3")
}
// 多个 if else语句
if num == 3 {
    // 执行语句
}else if num == 4 {                  // 通过 else if实现多个分支
    // 执行语句
}else {                              // 当不需要完整判断 else语句可以省略
    // 执行语句
}

// switch语句
num = 12
switch num {
case 2:
    print("num等于2")                // 每个case分支至少需要包含一条语句
    print("num等于2")                // case分支末尾不需要写break,不会发生贯穿
case 3, 4, 5:                       // case语句可以匹配多个值,之间用(,)隔开
    print("num == 3 or 4 or 5")
case 6..<10:                        // case语句也支持区间
    print("num大于等于6,且小于10")
case 10..<19 where num % 3 == 0:    // 使用where语句来增加额外判断条件
    print("num大于等于10,且小于19,且能被3整除")
default:
    print("上面的情况都不满足")
}

// 控制转移语句
num = 5
while num > 0{

    print(num)                       // 5  4  3  2  1
    num = num - 1
    if num == 2 {
        continue                     // 立刻终止本次循环,开始下一次循环
    }
}
num = 5
while num > 0{
    
    print(num)                       // 5  4  3
    num = num - 1
    if num == 2 {
        break                    // 立刻终止当前循环
    }
}

// continue与break的区别: continue会终止本次循环,再开始下一次循环,不会离开整个循环体.break:立刻终止整个循环,并离开当前循环体.

num = 2
switch num {
case 2:
    print("Hello")                  // Hello
    fallthrough                     // 贯穿,使用fallthrough可以连续到下一个case中
default:
    print("World")                  // World
}


// 给循环语句设置一个标签,方便识别终止循环
var num2 = 4
num = 6
numLoop: while num > 0{
    num2Loop: while num2 > 0{
        print(num2)                 // 4
        num2 = num2 - 1
        break numLoop               // 思考:如果不带numLoop标签,输出会是什么?
    }
    print(num)                      // 无打印
    num = num - 1
}

// guard语句
num2 = 4
func guardTest() {
    guard num2 == 5 else {        // 如果guard条件不满足,则会执行else后面的{}
        print(num2)               // 4
        return                    // 由于有return, guard语句需要在函数中
    }
}
guardTest()


// 版本适配: 在实际开发中通常需要适配多个版本
if #available(iOS 10, *) { // 平台还可以是: iOS macOS watchOS tvOS
    // 使用iOS10及以上的API
}else {
    // 使用iOS10以下的API
}

