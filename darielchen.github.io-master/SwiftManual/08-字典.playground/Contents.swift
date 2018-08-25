//: Playground - noun: a place where people can play

import UIKit

// 字典中的每个元素都是一个键值对,每个键值对有一个对应的key value
var chars: [String: String] = ["char1":"A", "char2":"B"] // 键和值都是String类型
var charDict = ["char1":"A", "char2":"B"]  // 系统会作自动类型推断,类型也可以省略

chars.count                                // 2
chars.isEmpty                              // false
chars["char3"] = "C"                       // chars中新增一个键值对
chars["char1"] = "a"                       // chars中修改key对应的value

chars.updateValue("b", forKey: "char2")    // 更新键值对,要是这个键不存在则会添加一个

print(chars)                               // ["char3": "C", "char2": "B", "char1": "a"]

chars["char2"]                             // b, 通过字典的key访问value
chars["char3"] = nil                       // 将key对应的value设置为nil,移除键值对
chars.removeValue(forKey: "char2")         // 移除键值对
print(chars)                               // ["char1": "a"]

// 字典遍历
for (key, value) in charDict {             // 遍历字典中的所有key value
    print("\(key): \(value)")              // char2: B 换行 char1: A
}
for key in charDict.keys {                 // 遍历字典中的所有key
    print(key)                             // char2 换行 char1
}

for value in charDict.values {             // 遍历字典中的所有value
    print(value)                           // B 换行 A
}

let arrKeys = [String](charDict.keys)   // ["char1", "char2"], 获取字典中所有key的数组
let arrValues = [String](charDict.values)   // ["A", "B"], 获取字典中所有value的数组
