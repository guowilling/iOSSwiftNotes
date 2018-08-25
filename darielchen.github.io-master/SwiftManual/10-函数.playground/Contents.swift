//: Playground - noun: a place where people can play

import UIKit

// 函数: 用来完成特定任务的独立代码片段

// 函数的定义与调用
// 定义:
func greet(person: String) -> String {      // func 函数名(参数名: 参数类型) -> 返回值类型
                                            // 函数内的代码块,此处省略
    return "Hello, \(person)!"              // return 返回值
}

// 调用:
let greetWord = greet(person: "Dariel")     // 函数名(参数名: 参数)
print(greetWord)                            // Hello, Dariel! 打印返回值


func say() -> String{                       // 函数无参数有返回值
    return "Hello"
}
print(say())                                // Hello

func say(person1: String, person2: String) -> String {  // 多个参数且有返回值
    return "Hello,\(person1) \(person2)"
}
print(say(person1: "Lily", person2: "Lucy")) // Hello,Lily Lucy

func sayHello() {                          // 无参数无返回值
    print("Hello")                         // Hello
}
sayHello()

// 求数组中的最大值和最小值
func minMax(array: [Int]) -> (min: Int, max: Int)? { // 使用元组返回多个参数
    if array.isEmpty {return nil}
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        }else if value > currentMax{
            currentMax = value
        }
    }
    return (currentMin, currentMax)         // 考虑到数组为空的情况,返回值为可选类型
}

let bounds = minMax(array: [3,5,6,12,8,10]) // bounds是一个元组类型
print(bounds!.max)                          // 通过点语法获取最值
print(bounds!.min)                          // !强制解包,表示一定有值

// 函数的参数标签和参数名称
// 参数标签是在函数调用的时候使用 参数名称是在函数的实现中使用
func someFunction(label name: String) -> String{ // label参数标签, name 参数名称
    return name                             // 在函数实现中用参数名称
}
someFunction(label: "Dariel")               // 在调用函数的时候用参数标签
// 参数标签的使用目的: 使函数在调用的时候的表达更有力,并且能够保持函数内部的可读性


// 忽略参数标签: 可以通过下划线(_)来代替标签
func ignoreLabel(_ name1: String, label2 name2: String) {
    print(name1 + name2)                    // LilyLucy
}
ignoreLabel("Lily", label2: "Lucy")         // 忽略的参数标签此处不会显示


func defaultLabel(label1 name1: String, label2 name2: String = "Lily") {
    print(name1 + name2)
}
defaultLabel(label1: "Lucy", label2: "Lilei")  // LucyLilei
defaultLabel(label1: "Lucy")                // LucyLily, 有默认参数可以省略

// 计算多个数的平均数
func avarageNum(_ num: Double...) -> Double { // 参数后面加...表示有多个参数
    var total: Double = 0
    for number in num {
        total += number
    }
    return total/Double(num.count)
}
avarageNum(2, 6, 4, 8, 7)                   // 5.4, 参数个数不限
avarageNum(5)                               // 注意: 一个函数只能有一个可变参数

// 输入输出参数
// 交换两个变量的值
func swapTwoInts(_ a: inout Int, _ b: inout Int) {  //  加inout可以传指针
    let temp = a
    a = b
    b = temp
}
var a = 2
var b = 3
swapTwoInts(&a, &b)                        // 此处传进去的是a,b两个变量的地址
print("a=\(a), b=\(b)")                    // a=3, b=2, swapTwoInts后a,b的值改变了



// 函数类型
var swap = swapTwoInts                     // swap的类型为(inout Int, inout Int) -> ()
swap(&a, &b)
print("a=\(a), b=\(b)")                    // a=2, b=3, 函数swap等价于swapTwoInts
// 可以把一个函数当作常量或变量赋值给一个常量或者变量


// 将函数作为参数
func sum(num1: Int, num2: Int) -> Int {   // 和
    return num1 + num2
}
func sub(num1: Int, num2: Int) -> Int {   // 差
    return num1 - num2
}

func mathNumber(_ mathFunc: (Int, Int) -> Int, _ a: Int, _ b: Int) -> Int{
    return (mathFunc(a, b))
}

mathNumber(sum, 4, 2)                      // 6, 将函数作为参数传进去
mathNumber(sub, 4, 2)                      // 2


// 函数类型作为返回类型
func chooseSumOrSun(_ isSum: Bool) -> (Int, Int) -> Int {
    return isSum ? sum : sub
}
chooseSumOrSun(true)(2, 4)                // 6, chooseSumOrSun(true) 等于 sum

// 嵌套函数
func chooseSumOrSub(isSum: Bool, _ a: Int, _ b: Int) -> Int {
    func sum(num1: Int, num2: Int) -> Int { return num1 + num2 }
    func sub(num1: Int, num2: Int) -> Int { return num1 - num2 }
    
    return isSum ? sum(num1: a, num2: b) : sub(num1: a, num2: b)
}

chooseSumOrSub(isSum: true, 4, 4)         // 8

