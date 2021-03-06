//: Playground - noun: a place where people can play

import UIKit

// 属性: 属性分为用来存储值的属性和用来计算值的属性
// 计算属性可用于类,结构体,枚举.存储属性只能用于类和结构体

// 存储属性:在特定的类和结构体中存储常量和变量
struct Location {                    // 描述位置的结构体
    var x: Double
    let y: Double
}

var position1 = Location(x: 22.22, y: 33.33) // 变量
position1.x = 20                    // 变量存储属性可以修改
//position1.y = 30                    // ❌, 常量存储属性不可修改

let position2 = Location(x: 20.2, y:30.3 ) // 结构体实例赋值给一个常量
//position2.x = 22.22                 // ❌, 变量属性也是不可修改的
// 这是因为结构体属于值类型,当值类型被声明为常量的时候,其所有属性也就成了常量

class Address {                     // 描述地址的类
    let city = "Hangzhou"
    var town: String?
}
let address1 = Address()            // 将一个实例赋值给常量
address1.town = "CangQian"          // 其变量属性仍然可变
// 而当把一个引用类型赋值给一个常量的时候,仍可以修改该实例的变量属性


// 延迟加载存储属性关键词lazy
class Data {
    var fileName = "data.plist"
    // 此处是比较耗时的数据加载工作
}
class DataManger {
    lazy var data = Data()         // 使用lazy第一次访问的时候才被创建
    // 对数据操作                    // lazy延时加载只能修饰变量,因为常量需要初始值
}
let manager = DataManger()         // 创建实例的时候并没有创建data实例
manager.data                       // 此时才会去执行耗时的数据加载工作
// 如果lazy修饰的属性没有被初始化就被多个线程访问,就会被初始化多次


// 计算属性:可用于类,结构体,枚举. 不直接存储值,而是提供了一个set和get方法
struct Size {
    var width = 0.0
    var height: Double {           // 设置height的get set方法
        get {                      // get方法必须有返回值
            print("get")           // get
            return 10.0            // height返回10.0
        }
        set {
            width = 20.0           // width设置为 20.0
            print("set")           // set
        }
    }
}
var size1 = Size()
size1.height = 17                  // 设置height值时调用set方法
print(size1.width)                 // 20.0
print(size1.height)                // 10.0, 获取height值的时候调用get方法




// 只读属性,只有get方法,没有set方法的属性
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {           // 必须用var修饰,计算属性值是不固定的
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print(fourByFiveByTwo.volume)      // 40.0, 可以通过点语法访问
//fourByFiveByTwo.volume = 20.0      // ❌, 不能设置新值


// 属性观察器,willSet, didSet: 只要为属性设置新值就会调用属性观察器
class StepCounter {
    var totalSteps: Int = 0 {      // 一定要设置初始值
        willSet {                  // willSet在新值被设置之前调用
            print(newValue)        // newValue为默认参数名称
        }
        didSet(oldSteps) {         // didSet在新值被设置之后调用
            print(oldSteps)        // 修改默认参数oldValue为oldSteps
        }
        // willSet会将新的属性值传入newValue参数,didSet会将旧的属性值传入oldSteps
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 23        // newValue:23 oldSteps: 0
stepCounter.totalSteps = 5         // newValue:5  oldSteps: 23


// 全局变量和局部变量
// 全局变量是在函数,方法,闭包或任何类型之外定义的变量
// 局部变量是在函数,方法或闭包内部定义的变量


// 类型属性
// 实例属性: 每创建一个实例,该实例都会拥有一套属于自己的值,实例之间的属性相互独立
// 类型属性: 也可以为类型定义属性,无论创建多少个该类型的示例,该属性都只有唯一一份

struct someStruct {
    static var typeProperty = "Value" // 使用static定义类型属性
}

class someClass {
    static var typeProperty = "Value"
    static var computedTypeProperty: Int {
        return 6                   // 可以通过闭包返回属性值
    }
}

print(someStruct.typeProperty)     // Value, 类型属性直接通过其本身来访问
someStruct.typeProperty = "Another value" // typeProperty为var类型,可写
print(someStruct.typeProperty)     // Another value
print(someClass.computedTypeProperty)  // 6