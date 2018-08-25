//: Playground - noun: a place where people can play

import UIKit

// 错误处理: swift在运行时能够对错误进行处理并给出相应的操作.
// 处理错误的几种方式: 把错误传递给调用函数,然后使用do-catch语句处理错误 将错误作为可选类型处理 使用断言处理
// 定义错误类型
enum CustomErrorType: Error {                 // 通过枚举构建一组相关的错误状态
    case errorReason1
    case errorReason2
    case errorReason3
}


// 通过throwing函数传递错误
// throwing函数: 在参数列表后面加throws,表示可以抛出错误
class ThrowClass {
    var num: Int?                                // 根据num值抛出异常
    func throwFunc() throws {                    // 如果有返回类型,throws需要写在(->)前面
        guard num == 1 else {                    // 当num != 1 执行throw抛出异常
            throw CustomErrorType.errorReason1   // 异常会传递到函数被调用的作用域
        }                                        // throw语句会立刻退出当前方法,相当于return
        guard num == 2 else {
            throw CustomErrorType.errorReason2
        }
        guard num == 3 else {
            throw CustomErrorType.errorReason3
        }
    }
}


// 通过Do-Catch处理throwing函数传递的错误
let throwClass = ThrowClass()
throwClass.num = 4

do {
    try throwClass.throwFunc()
}catch CustomErrorType.errorReason1 {        // 根据返回错误类型,执行这个{}
    print("errorReason1")                    // errorReason1
}catch CustomErrorType.errorReason2 {
    print("errorReason2")
}catch {                                     // catch没有指定类型,那么可以匹配任何错误
    print("errorReason3")
}


// 将错误转换成可选值
func someThrowingFunc(num: Int) throws -> Int { // 当num不为3的时候会抛异常,否则返回3
   
    defer {
        print("defer语句会在return,break,以及错误抛出之前执行")
    }
    
    defer {
        print("defer语句可以有多个,注意多个之间的执行顺序")
    }
   
    guard num == 3 else {
        throw CustomErrorType.errorReason1
    }
    
    return num
}

let x = try? someThrowingFunc(num: 3)         // 如果throwing函数抛出一个异常,那么x为nil
print(x)                                      // Optional(3),x就是函数返回值

let y: Int?                                   // 函数的返回值是Int
do {
    y = try someThrowingFunc(num: 2)
}catch CustomErrorType.errorReason1 {
    print("errorReason1")                     // errorReason1
}

if let dataValue = try? someThrowingFunc(num: 2) { // 可以用try?写的更加简洁
    print(dataValue)
}else {
    print("dataValue为空")                     // dataValue为空
}


// 禁用错误传递:如果觉得这个地方肯定不会有错误抛出,可以禁用错误传递
let forbiddenX = try! someThrowingFunc(num: 3) // try?变为try!


// defer语句:在异常抛出前,通常需要做一些操作,比如关闭文件,手动释放内存等,这些就可以在defer语句中执行
// defer语句会在return,break,以及错误抛出之前执行
// defer语句可以有多个
// defer语句必须要在throw语句前面才能执行


// 使用断言:如果当前值缺失,或者不满足特定条件,可以使用断言使程序崩溃,并在控制台输出原因
var age = 3
assert(age > 0, "这个年龄不符合逻辑")            // 格式:assert(布尔表达式,"控制台输出内容")
age = -5
//assert(age > 0, "这个年龄不符合逻辑")          // 布尔表达式为false时,使程序崩溃并输出内容




