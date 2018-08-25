//: Playground - noun: a place where people can play

import UIKit

// 下标: 定义在类结构体枚举中,可以快速访问集合列表序列

//subscript(index: Int) -> Int {        // 下标语法
//    get {
//        // 返回一个整数类型
//    }
//    set(newValue) {
//        // 执行赋值操作
//    }
//}


// 只读下标的实现
struct TimeTable {
    let multiplier: Int
    subscript(index: Int) -> Int {        // 用来表示传入整数的乘法
        return multiplier * index
    }                                     // 省略set,下标定义为只读的
}
let threeTimesTable = TimeTable(multiplier: 3) // 通过构造函数赋值给实例成员属性
print(threeTimesTable[6])                 // 18, 通过下标访问实例传入参数并获取返回值



// 下标的用法
struct Matrix {
    var rows: Int, columns: Int
    subscript(row: Int, column: Int) -> Int { // 二维下标
        get {
            return rows + columns
        }
        set {                             // 默认参数newValue
            rows += newValue
            columns += newValue
            
            rows += row
            columns += column
        }
    }
}

var matrix = Matrix(rows: 2, columns: 3)
matrix[2, 2] = 8                         // 调用下标的set和get方法
print(matrix.columns)                    // 13
print(matrix.rows)                       // 12



