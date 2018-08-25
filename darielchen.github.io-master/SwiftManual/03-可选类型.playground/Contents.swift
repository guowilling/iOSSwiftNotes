//: Playground - noun: a place where people can play

import UIKit

// 可选类型的两种状态: 有值 没有值
// 作用:任何的常量或者变量都会有两种状态, 有值或者值缺失的状态.

var errorCode: Int? = 404                // 在类型后面添加一个?
print(errorCode)                         // Optional(404)
//errorCode = nil                          // 对非可选类型赋值nil会报错
print(errorCode)                         // nil


var errorMessage: String?                // 只声明可选类型没赋值,会默认设置为nil
// swift中nil的含义:nil是一个值,表示常量或变量的缺失,所以任何类型都可以设置为nil

// if语句强制解析,可选类型不能直接使用需要转化
if errorCode != nil {                    // 确定可选类型包含值后可以在变量名后加!强制解析
    print(errorCode!)                    // 404
}
//print(errorMessage!)                   // ❌,对为nil的变量强制解析会报错

// 可选绑定,将可选类型赋值给一个临时的变量或者常量
if let code = errorCode {
    print(code)                          // 输出:404, 自动解析
}else {
//    print(code)                        // ❌,code是局部变量
    print(errorCode)                     // 如果errorCode = nil此处输出nil
}

// 隐式解析可选类型:因为一定有值,所以可以免去解析的麻烦
let assumedString: String! = "A"         // 格式: 可选类型的?改成!
print(assumedString)                     // A
if let TempString = assumedString {      // 隐式解析可选类型可以被当做普通可选类型来使用
    print(TempString)                    // A
}


