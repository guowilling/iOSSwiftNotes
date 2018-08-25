//: Playground - noun: a place where people can play

import UIKit

// 字符串: 一个有序的字符类型的集合

// 字符串字面量
let someString = "literal"                   // 通过""包裹字符串,为常量变量提供初始值

// 初始化空字符串
var emptyString1 = ""                        // 空字符串,""内为空
let emptyString2 = String()                  // 空字符串,通过String()初始化方法置为空

emptyString2.isEmpty                         // true, 通过isEmpty方法判断是否为空

// 字符串可变性
emptyString1 = "Not Empty"                   // Not Empty, 变量字符串可变
//emptyString2 = "Change Constant String"      // 常量字符串不可变

// 字符串的值传递方式是通过值传递的 

// 字符串中字符的获取
for char in emptyString1.characters {        // for循环后面会详述
//    print(char)                              // 分16次输出emptyString1中字符
}
emptyString1.characters.count                 // 9, 获取字符串中字符个数包括空格

// 字符类型
let char: Character = "a"                   // a

// 字符串和字符的拼接
var string1 = "Hello"
var string2 = " World"
var string3 = string1 + string2              // Hello World, 通过+将两个字符串相连

string1 += string2                           // Hello World, 等价于string1 = string1+string2
string1.append(" !")                         // Hello World !, 通过append拼接

// 字符串的插值
let messages = "Hello \(string2) !"          // Hello World !, 通过将常量或变量放入\()中,完成常量或变量的替换和插入

// 字符串中字符的索引
let messChar = messages[messages.startIndex]                  // H,通过第一个字符的索引获取字符
let firstIndex = messages.index(after: messages.startIndex)   // 1, 第一个字符的索引
let lastIndex = messages.index(before: messages.endIndex)     // 13, 最后一个字符的索引
let index = messages.index(messages.startIndex, offsetBy: 4)  // 4, 初始位置偏移4
messages[index]                                               // o

//messages[messages.endIndex]                     // ❌, 注意:索引不能越界

// 插入和删除
var welcome = "Hello"
welcome.insert("!", at: welcome.endIndex)         // Hello!, 将!插入welcome的末尾
welcome.insert(contentsOf: "world".characters, at: welcome.index(before: welcome.endIndex))
                                            // Helloworld!, 注意:插入的内容是:"world".characters

welcome.remove(at: welcome.index(before: welcome.endIndex)) // !
print(welcome)                                  // Helloworld, 删除最后一位
let range = welcome.index(welcome.endIndex, offsetBy: -5)..<welcome.endIndex // 一个后5位的范围
welcome.removeSubrange(range)                  // welcome的值为Hello

//注意: insert(_:at:)  insert(contentsOf:at:)  remove(at:) removeSubrange(_:)方法在 Array, Dictionary和Set中都能够使用

// 比较字符串
// 字符串,字符相等
welcome == "Hello"                           // 字符串可以用==, !=进行比较操作
welcome != "Hello"

// 前缀相等
welcome.hasPrefix("Hel")                     // true 是否有特定的前缀

// 后缀相等
welcome.hasSuffix("llo")                     // true 是否有特定的后缀

