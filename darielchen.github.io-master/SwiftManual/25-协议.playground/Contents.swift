//: Playground - noun: a place where people can play

import UIKit

// 协议:定义一个规则去实现特定功能.类 结构体 枚举都可以遵守这个协议,并为这个协议的规则提供具体实现
protocol SomeProtocol1 {                 // 协议语法
    // 协议内容
}

struct SomeStructure: SomeProtocol1 {    // 遵守协议,冒号(:)后面加协议名称,多个协议之间用逗号隔开
    // 结构体内容
}

class SomeClass: NSObject, SomeProtocol1 { // 有父类的类遵守协议,要将父类名放在协议名之前,用逗号隔开
    // 类的实现
}


// 在协议中定义属性: 协议中的属性可以是实例属性也可以是类型属性,协议中的属性只能指定名称和类型以及可读可写
protocol SomeProtocol2 {
    var mustBeSettable: Int { get set }  // 类型后面加{ get set }表示该属性可读可写
    var onlyRead: Int { get }            // 类型后面加{ get }表示该属性可读
    static var someTypeProperty: Int { get set } // 类型属性前面加关键字static
}

protocol FullyNamed {                   // 这个协议中只包含一个实例属性
    var fullName: String { get }
}

struct Person: FullyNamed {             // Person遵守FullyNamed协议表示必需要实现fullName属性
    
    var name: String
    
    var fullName: String {              // 这个fullName属性可以实现为只读的
        return "Barack Hussein \(name)"
    }
}
let obama = Person(name: "Obama")
print(obama.fullName)                   // Barack Hussein Obama



// 在协议中定义方法: 协议可以要求实现某些指定的实例方法和类方法,定义的方式和普通方法相同,但不需要大括号和方法体
protocol SomeProtocol3 {
    static func someTypeMethod()       // 定义类方法的时候用static作前缀
}

protocol RandomNum {                   // 要求遵守协议的类型必须有一个名为random的方法
    func random() -> Int
}
class RandomNumGenerator: RandomNum{
    func random() -> Int {
        return Int(arc4random() % 10)
    }
}
let randomNum = RandomNumGenerator()
print(randomNum.random())             // 0~9的随机数



// Mutating关键字在协议中的应用: 在结构体和枚举即值类型的实例方法中,不能直接修改其实例属性,需要在其方法前面加mutating关键字
protocol toggleProtocol {
    mutating func toggle()           // 对于需要结构体和枚举遵守的协议方法需要在前面添加mutating
}

enum Toggle: toggleProtocol {
    case Off, On
    mutating func toggle() {
        switch self {
        case .Off:
            self = .On
        case .On:
            self = .Off
        }
    }
}

var lightSwitch = Toggle.Off
lightSwitch.toggle()                 // 置反
print(lightSwitch == .On)            // true



// 在协议中定义构造器: 写下构造器的声明,但不需要写花括号和构造器实体
protocol SomeProtocol4 {
    init(someParameter: Int)
}

class SomeInitClass: SomeProtocol4 {
    // 遵守协议的构造器都必须在前面带required修饰符,来确保所有子类都要实现此构造器
    required init(someParameter: Int) {
        // 构造器实现部分
    }
}


// 协议作为类型使用: 可以作为函数 方法或构造器中的参数类型或返回值类型,作为常量变量或属性的类型,作数组字典或其他容器中元素的类型
class Dice {                         // 定义一个骰子
    let generator: RandomNum         // 协议类型的存储属性
    
    init(generator: RandomNum) {
        self.generator = generator
    }
    
    func roll() -> Int {             // 产生一个随机数
        return generator.random()
    }
}

class RandomNumGenerator1: RandomNum{ // 定义一个类遵守该协议
    func random() -> Int {
        return Int(arc4random() % 10)
    }
}

var d6 = Dice(generator: RandomNumGenerator1()) // 就可以将遵守该协议的类当作参数了
print(d6.roll())                     // 随机数



// 代理设计模式: 可以将类或结构体的一些功能委托给其他类型去实现.代理可以用来响应事件,或接收外部数据源数据

protocol BabyDelegate {
    func feedBaby(baby: Baby)        // 代理中有一个喂食物的方法
}

class Baby {
    var needNumFood: Int?            // baby需要的食物数量
    var babyDelegate: BabyDelegate?  // 代理属性
    
    func eat() {                     // 吃这个方法
        babyDelegate?.feedBaby(baby: self)  // 调用代理方法
    }
}

class Nanny: BabyDelegate{         // nanny遵守代理

    func feedBaby(baby: Baby) { // nanny实现喂食物的代理方法
        baby.needNumFood = 10
        print("喂baby食物:\(baby.needNumFood!)") // 喂baby食物:10
    }
}

let baby = Baby()
let nanny = Nanny()

baby.babyDelegate = nanny            // 将baby委托给nanny
baby.eat()                           // baby调用吃的方法委托nanny喂食物


// 在extension中实现协议
protocol SomeProtocol5 {
    // 协议内容
}
extension Nanny: SomeProtocol5 {    // 在扩展中遵守协议的效果和在原始类中一样
    // 在实际开发中实现协议的时候推荐这样做,有利于提高代码的阅读性
}



// 通过扩展遵守协议: 当一个类实现了协议中的方法,却还没有遵守该协议时,可以通过空扩展体来遵守该协议
protocol SomeProtocol6 {
    var description: String { get }
}
struct Cat {                         // 并没有遵守协议
    var name: String
    var description: String {        // 实现协议中的方法
        return "A cat named: \(name)"
    }
}
extension Cat: SomeProtocol6 {}      // 在扩展中实现协议


let lucyTheCat = Cat(name: "lucy")
let sp: SomeProtocol6 = lucyTheCat   // 遵守协议
print(sp.description)                // A cat named: lucy



// 协议本身也是种类型,可以放到集合中使用
let things: [SomeProtocol6] = [lucyTheCat] // 用于存放遵守协议的类

for thing in things {
    print(thing.description)         // A cat named: lucy
}



// 协议的继承: 和类的继承相似,但协议可以继承一个或多个其它协议
protocol InheritingProtocol: SomeProtocol5, SomeProtocol6 {
    // 任何实现InheritingProtocol协议的同时,也必须实现SomeProtocol5和SomeProtocol6
}


// 类的专属协议: 通过添加class关键字来限制协议只能被类遵守
protocol SomeClassOnlyProtocol: class, InheritingProtocol { // class关键字必须出现在最前面
    // 如果被结构体或枚举继承则会导致编译错误
}


// 协议合成: 同时采纳多个协议,多个协议之间用 & 分隔.协议的合成并不会生成新的协议类型,只是一个临时局部的
protocol Name {
    var name: String { get }
}
protocol Age {
    var age: Int { get }
}

struct People: Name, Age {          // 遵守name age这两个协议
    var name: String
    var age: Int
}

func say(to people: Name & Age) {   // 参数类型:Name & Age
    print("This is \(people.name), age is \(people.age)") // This is Joan, age is 20
}

let p = People(name: "Joan", age: 20)
say(to: p)                          // 只要遵守这两个协议的对象都能被传进去



// 检查协议的一致性,如果不一致可以进行转换
// is 检查实例是否符合某个协议,符合返回true,否则返回false
// as? 如果符合某个协议类型,返回类型为协议类型的可选值, 否则返回nil
// as! 将实例强制转化为某个协议类型,如果失败会引发运行时错误
protocol HasArea {                  // HasArea协议
    var area: Double { get }
}
class Circle: HasArea {             // 遵守HasArea协议
    let pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius}
    init(radius: Double) { self.radius = radius }
}

class Country: HasArea {           // 遵守HasArea协议
    var area: Double
    init(area: Double) { self.area = area }
}

class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}

// 将所有类对象作为AnyObject对象放到数组中
let objects: [AnyObject] = [ Circle(radius: 3.0), Country(area: 23460), Animal(legs: 4)]

for object in objects {
    if let objectWithArea = object as? HasArea { // 判断object是否遵守area协议
        print(objectWithArea.area)               // 此时的objectWithArea是area协议类型的实例
//        print(objectWithArea.pi)               // ❌, 所以只有area属性才能被访问
    }else {
        print("没有遵守area协议")
    }
}


// 协议的可选要求: 协议中的所有方法,属性并不都是一定要实现的,可以在可实现可不实现的方法前面加optional关键字,使用可选方法或属性时,它们的类型会自动变为可选的
// 注意: 可选的协议前面需要加@objc关键字.
//      @objc:表示该协议暴露给OC代码,但即使不与OC交互只想实现可选协议要求,还是要加@objc关键字.
//      带有@objc关键字的协议只能被OC类,或者带有@objc关键字的类遵守,结构体和枚举都不能遵守.
@objc protocol CounterDataSource { // 用于计数的数据源
    @objc optional var fixAdd: Int { get } // 可选属性
    @objc optional func addForCount(count: Int) -> Int // 可选方法,用于增加数值
}

class Counter: CounterDataSource {
    var count = 0                // 用来存储当前值
    var dataSource: CounterDataSource?
    func add() {                 // 增加count值
        // 使用可选绑定和两层可选链式调用来调用可选方法
        if let amount = dataSource?.addForCount?(count: count) {
            count += amount
        }else if let amount = dataSource?.fixAdd {
            count += amount
        }
    }
}

class ThreeSource: NSObject, CounterDataSource {
    let fixAdd = 3
}


var counter = Counter()
counter.dataSource = ThreeSource() // 将counter的数据源设置为ThreeSource
counter.add()                      // 增加3
counter.add()                      // 增加3
print(counter.count)               // 6



// 协议的扩展: 可以通过扩展来为遵守协议的类型提供属性 方法 下标
protocol RandomNumG {
    func random() -> Int
}
class RandomNumGen: RandomNumG {
    
    var description: String {
        return "RandomNumGen"
    }
    
    func random() -> Int {
        return Int(arc4random() % 10) // 返回一个0~9的随机数
    }
}

let randomNumG = RandomNumGen()
print(randomNumG.random())             // 0~9的随机数

extension RandomNumG {
    
    var description: String {
        return "extension"
    }
    
    func randomBool() -> Bool {        // 可以通过扩展来为协议添加方法
        return random() > 4            // 随机数是否大于4
    }
}
print(randomNumG.randomBool())         // bool值
print(randomNumG.description)          // RandomNumGen,协议扩展中的默认属性的优先级比自定义属性低
