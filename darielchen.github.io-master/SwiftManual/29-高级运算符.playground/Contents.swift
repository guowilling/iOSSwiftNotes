//: Playground - noun: a place where people can play

import UIKit

// 位运算符:操作数据结构中每个独立的比特位

// ~ : 按位取反运算符
let bits: UInt8 = 0b0011          // UInt8的范围为:0~255,bits表示十进制的3
let invertBits = ~bits            // 252, 按位取反运算符(~),表示全部位取反

// & : 按位与运算符
let firstTwoBits = 0b10           // 十进制的2
let secondTwoBits = 0b11          // 十进制的3
let fourBits = firstTwoBits & secondTwoBits // 十进制的2, 按位与结果为0b10

// | : 按位或运算符
let combinedBits = firstTwoBits | secondTwoBits // 十进制的2, 按位或结果为0b11

// ^ : 按位异或运算符
let outputBits = firstTwoBits ^ secondTwoBits // 十进制的1, 按位或结果为0b01

// << >> : 按位左移 右移运算符
let shiftBits: UInt = 0b00110     // 十进制的6
shiftBits << 1                    // 0b01100, 左移动一位产生一个新的值,十进制的12
shiftBits >> 1                    // 0b00011, 右移动一位产生一个新的值,十进制的3



// 溢出运算符: 当一个数值超过了它的有效范围,swift会报错
var overflowInt: UInt8 = 255      // UInt8的范围为:0~255
//overflowInt = 256               // ❌
//overflowInt = -1                // ❌, 只要数不在范围内,不管值过大还是过小都会报错

// 数值的溢出直接报错太不友好了,其实可以做截断处理的
// 有以下几种方法可以处理: 溢出加法 &+ 溢出减法 &- 溢出乘法 &*
overflowInt = UInt8.max           // 最大整数255
overflowInt = overflowInt &+ 1    // 0, 二进制加一的时候发生溢出就变成了00000000
overflowInt = UInt8.min
overflowInt = overflowInt &- 1    // 255, 当对其最小值进行减1,也会发生溢出变为11111111


// 运算符函数: 可以通过运算符操作类和结构体
struct Point {
    var x = 0.0, y = 0.0
}
// 加法运算符
extension Point {
    // 该运算符函数需要接受两个Point类型参数,返回一个Point类型值
    static func + (left: Point, right: Point) -> Point {
        return Point(x: left.x + right.x, y: left.y + right.y)
    }
}
let point = Point(x: 2.0, y: 3.0)
let anotherPoint = Point(x: 1.0, y: 2.0)
print(point + anotherPoint)       // Point(x: 3.0, y: 5.0)

// 前缀和后缀运算符
extension Point {
    // 实现前缀或者后缀运算符需要在声明运算符的函数的时候在func之前加prefix和postfix关键字
    static prefix func - (point: Point) -> Point {
        return Point(x: -point.x, y: -point.y)
    }
}
let position = Point(x: 3.0, y: 4.0)
print(-position)                  // Point(x: -3.0, y: -4.0)

// 复合赋值运算符
extension Point {
    // 需要把左边的参数设置为inout,因为这个参数会在运算符内被修改
    static func += (left: inout Point, right: Point) {
        left = left + right
    }
}
var original = Point(x: 1.0, y: 3.0)
let pointToAdd = Point(x: 2.0, y: 3.0)
original += pointToAdd
print(original)                   // Point(x: 3.0, y: 6.0)

// 等价运算符
extension Point {
    // 通过函数来判断Point中的两个属性是否相等
    static func == (left: inout Point, right: Point) -> Bool {
        return (left.x == right.x) && (left.y == right.y)
    }
    // 通过调用相等运算符函数来判断两个Point不等
    static func != (left: inout Point, right: Point) -> Bool {
        return !(left == right)
    }
}
var twoThree = Point(x: 2.0, y: 3.0)
let anotherTwoThree = Point(x: 2.0, y: 3.0)
print(twoThree == anotherTwoThree) // true
print(twoThree != anotherTwoThree) // false


// 自定义运算符: 除了使用系统的运算符,swift还支持自定义
// 使用operator关键字定义新的运算符,同时还要指定 prefix infix postfi
prefix operator +++               // 需要先定义好双自增运算符
extension Point {
    static prefix func +++ (point: inout Point) -> Point {
        point += point            // 调用 +=运算符函数
        return point
    }
}
var toBeDouble = Point(x: 2.0, y: 2.0)
+++toBeDouble
print(toBeDouble)                 // Point(x: 4.0, y: 4.0)
