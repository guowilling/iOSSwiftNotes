//: Playground - noun: a place where people can play

import UIKit

// 泛型: 使用泛型能更清晰更简洁的表达代码意图


// 泛型所解决的问题
func swapTwoInts(a: inout Int, _ b: inout Int) { // 交换两个Int的值
    let temp = a
    a = b
    b = temp
}
var someInt = 3
var anotherInt = 5
swapTwoInts(a: &someInt, &anotherInt)
// 但如果想交换String Double类型的数该怎样做呢?再写两个函数?


// 泛型函数: 在函数名后面添加<T>,表示T是函数定义的占位类型,只要前后一致,别的字母也可以
func swapTwoValues<T>(a: inout T, _ b: inout T) { // 用T来替代实际类型,a和b是同一类型T
    let temp = a
    a = b
    b = temp
}
swapTwoValues(a: &someInt, &anotherInt) // 在调用函数时,根据实际类型推断出T的类型

var StringA = "A"
var StringB = "B"
swapTwoValues(a: &StringA, &StringB) // 只要传入任何相同的类型都可以
print("StringA:\(StringA),StringB:\(StringB)") // StringA:B,StringB:A


// 类型参数
// 在上面的例子中占位类型T就是一个类型参数.
// 类型参数可以在函数名后面加一个占位类型, 并用尖括号括起来.例如<T>
// 类型参数设定后,就可以当做函数的参数类型使用了,可以是参数类型也可以是返回类型
// 当函数被调用的时候,类型参数会被转化为实际类型
// 类型参数可以有多个,可以写在尖括号中,用逗号隔开
// 通常使用单个字母T U V来命名类型参数,但也可以是以大写字母开头的字符串


// 泛型类型: 能够让自定义类,结构体和枚举适用于任何类型,类似于Array和Dictionary
struct Stack<Element> {                 // 模拟栈的操作过程的泛型集合类型
    var items = [Element]()             // 使用Element为空数组进行初始化
    mutating func push(item: Element) { // push的参数类型是Element
        items.append(item)
    }
    mutating func pop() -> Element {    // pop的返回值类型是Element类型
        return items.removeLast()
    }
}
var stackOfStrings = Stack<String>()    // 在尖括号中写出栈中需要存储的数据类型
stackOfStrings.push(item: "A")
stackOfStrings.push(item: "B")
stackOfStrings.push(item: "C")
let fromTheTop = stackOfStrings.pop()
print(stackOfStrings.items)             // ["A", "B"]



// 泛型类型的扩展: 原类型中的类型参数在扩展中可以直接使用
extension Stack {
    var topItem: Element? {             // 返回栈顶元素的只读计算属性
        return items.isEmpty ? nil : items[items.count - 1]
    }
}
if let topItem = stackOfStrings.topItem {
    print("topItem:\(topItem)")         // topItem:B
}



// 类型约束:swapTwoValues(_:_:)和Stack适用于任何类型,但有时我们需要对类型进行一些约束,这些约束可以是类型参数必须继承指定类,或者符合特定的协议或协议组合
class SomeClass {}
protocol SomeProtocol {}
// T的类型参数必须是SomeClass的子类,U的类型参数必须遵守SomeProtocol协议
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) { // 类型约束语法
}

// 根据字符串查找在数组中的索引
func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
    for (index, value) in array.enumerated() {
        // 为T增加一个Equatable协议,遵循该协议的类型必须实现等式符和不等符号.才可以对两个类型进行比较
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let doubleIndex = findIndex(of: 5.0, in: [3.2, 1.0, 5.0, 5,6]) // 2
let stringIndex = findIndex(of: "O", in: ["V", "D", "E", "O"]) // 3



// 类型的关联: 关联类型为协议中某个类型提供别名
protocol Container {                     // 定义一个Container协议
    associatedtype ItemType              // 通过associatedtype关键词来定义一个关联类型
    mutating func append(item: ItemType) // 添加一个新的元素到容器里
    var count: Int { get }               // 获取容器中的元素个数
    subscript(i: Int) -> ItemType { get } // 通过索引获取容器中的元素
}

struct NewStack<Element>: Container {
    var items = [Element]()
    mutating func push(item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    mutating func append(item: Element) {
        self.push(item: item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {       // swift会自动推断Element就是ItemType类型
        return items[i]                  // 不需要再去指定ItemType类型为Element类型
    }
}


// where子句: 为泛型的类型参数做一些约束
// where语句指定C1和C2的类型必须一致,且C1遵循Equatable协议
func allItemMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
    // 检查两个容器是否含有相同的元素
    if someContainer.count != anotherContainer.count {
        return false
    }
    // 检查每一对元素是否相等
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }
    return true
}

var stackOfString = NewStack<String>()
stackOfString.push(item: "O")
stackOfString.push(item: "P")
stackOfString.push(item: "Q")

var arrayOfString = NewStack<String>()
arrayOfString.items = ["O", "P", "Q"]
if allItemMatch(stackOfString, arrayOfString) { // 判断两个遵循Container协议的数组元素是否一致
    print("全部元素匹配")                   // 全部元素匹配
}else {
    print("元素不全部匹配")
}
