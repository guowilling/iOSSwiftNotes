//: Playground - noun: a place where people can play

import UIKit

// 集合: 存储相同类型没有确定顺序的元素,相同元素只能出现一次
var char1 = Set<Character>()          // 创建一个Character类型的空集合
let char2:Set<Character> = []         // 定义空集合的简便方法.类型:Set<Character>

// 类型设置
var letter1: Set = ["a", "b", "c"]   // 集合类型可以写成Set,但必须显示声明,不能省略
var letter2 = ["a", "b", "c"]        // Set省略后根据类型推断,letter2就是数组类型

// 访问修改集合
letter1.count                        // 3, 统计元素个数
letter1.isEmpty                      // false, 判断是否为空
letter1.insert("a")                  // 如果插入的元素如果已经在集合中,那么会被忽略
print(letter1)                       // ["b", "a", "c"], 元素没有顺序
letter1.remove("c")                  // c, 要删除的元素在集合中,则返回元素,否则返回nil
print(letter1)                       // ["b", "a"]
letter1.contains("a")                // true, 是否包含某个元素

// 遍历
for char in letter1 {
    print(char)                      // 不按顺序的输出集合中每个元素
}

for char in letter1.sorted() {
    print(char)                      // 按特定顺序的输出集合中每个元素
}

// 集合操作
var num1: Set = ["3", "2", "1", "5", "7"]
let num2: Set = ["3", "2", "1", "5", "7"]
let num3: Set = ["1", "3", "5"]

num1.intersection(num2)              // ["1", "3", "5"], 两个集合都包含的值的集合
num1.union(num2)                     // 两个集合的所有元素组成的集合
num1.subtracting(num2)               // ["2", "7"], 只在num1中有的元素组成的集合
num1.symmetricDifference(num2)       // 在一个集合中但不在两个集合中的元素组成的集合

num2 == num3                         // false, 判断两个集合包含的元素是否都相同
num3.isSubset(of: num2)              // true, num3是num2的子集
num2.isSuperset(of: num3)            // true, num2是num3的超集合
num1.isDisjoint(with: num3)          // false, 判断两个集合中的元素是否都不相同

