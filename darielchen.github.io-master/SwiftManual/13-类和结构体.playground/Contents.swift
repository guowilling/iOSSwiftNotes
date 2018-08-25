//: Playground - noun: a place where people can play

import UIKit

// 类和结构体有相同的语法规则,都可以定义属性和添加方法来扩展功能
// 类和结构体的共同点:通过定义属性存储值;通过定义方法提供功能;通过点语法来访问实例所包含的值;通过定义构造器生成初始化值;通过使用扩展增加功能; 通过实现协议提供额外的功能

// 类还有的功能:允许一个类继承另一个,允许在运行时检查和解释一个实例类型,允许引用计数器对一个类的多次引用

// 结构体还有的功能: 结构体通过复制的方式在代码中传递,不使用引用计数器



// 定义语法
class ClassName {                       // 类名首字母用大写,属性名和方法名的首字母用小写
    // 具体内容
}
struct StructureName {                   // 结构体的首字母也大写
    // 具体内容

}
// 实例化类和结构体,访问属性
struct Resolution {                    // 定义名为Resolution的结构体
    var width = 0                      // 包含宽高两个Int类型的存储属性
    var height = 0
}
class VideoMode {                      // 定义名为VideoMode的类
    var resolution = Resolution()      // 初始化一个新的Resolution结构体实例
    var interlaced = false             // 定义默认值为false的布尔类型
    var frameRate = 0.0                // 默认值为0.0的Double类型
    var name: String?                  // 默认值为nil的String可选类型
}

// 实例化结构体和类
let someResolution = Resolution()      // 属性都被初始化为默认值
let someVideoMode = VideoMode()
print(someResolution.width)            // 0, 通过点语法访问属性
someVideoMode.resolution.height = 32   // 可以直接为子属性赋值
print(someVideoMode.resolution.height) // 32, 访问子属性

// 结构体的逐一构造器
let initRes1 = Resolution(width: 64, height: 48) // 结构体可设置属性的默认构造器
print("\(initRes1.width), \(initRes1.height)") // 64, 48
// 类没有默认构造器,需要自定义


// 结构体和枚举的值传递都是通过值拷贝
var initRes2 = initRes1                // 相当于拷贝了一份initRes1给initRes2
print(initRes1.width)                  // 64,
print(initRes2.width)                  // 64, 改变前的值
initRes2.width = 32
print(initRes1.width)                  // 64,
print(initRes2.width)                  // 32, initRes1的改变不会影响initRes2

enum Direction {                       // 枚举
    case North, South, East, West
}
var direct1 = Direction.North
var direct2 = direct1
direct2 = Direction.South
print(direct1)                         // North,direct2的值改变不会影响direct1
print(direct2)                         // South

// 类是引用拷贝,拷贝后的值的改变会影响原来的
let videoM1 = VideoMode()
videoM1.name = "VideoM1"
// videoM1传递的是一个引用,videoM2还是指向videoM1那一块存储空间
var videoM2 = videoM1
videoM2.name = "videoM2"
print(videoM1.name!)                   // videoM2
print(videoM2.name!)                   // videoM2, videoM2的属性改变会影响带videoM1

// 等价于用"==="三个等于表示,表示两个类型的常量或变量是否引用同一个实例
print(videoM1 === videoM2)            // true, 使用"==="判断两个引用是否指向同一个对象


// 类和结构体的选择
// 考虑结构体的情况: 只是用来封装少量简单的数据值,实例被赋值或传递的时候需要进行值拷贝,存储的值也需要被拷贝,不需要用到继承既有类型
// 考虑类的情况: 需要包含复杂的属性方法,能形成一个抽象的事物描述;需要用到继承;需要用到引用拷贝


// String Array Dictionary 的底层都是通过结构体实现的,所以它们在被赋值的时候都是通过值拷贝,当然了swift在内部会做性能优化,只有在必要的时候才会进行值拷贝.
