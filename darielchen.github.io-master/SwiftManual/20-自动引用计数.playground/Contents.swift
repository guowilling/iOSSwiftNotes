//: Playground - noun: a place where people can play

import UIKit

// ARC(Auto Reference Counteting)自动引用计数:swift会通过ARC来自动管理内存.当类的实例不再被使用的时候,会自动释放其占用的内存
// 类和结构体是值类型,而引用计数只能应用于引用类型,比如说类

// 自动引用的工作机制:为了保证实例在使用的过程中不被销毁,ARC会自动计算一个实例被引用的次数,只要引用次数不等于0,该实例都不会被销毁

// 自动引用计数实践
class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name)正在被初始化")
    }
    deinit {
        print("\(name)即将被销毁")          // person3 = nil时打印
    }
}
var person1: Person?                      // 可选类型的变量,方便置空
var person2: Person?
var person3: Person?
person1 = Person(name: "Dariel")          // Person实例与person1建立了强引用
person2 = person1                         // 只要有一个强引用在,实例就能不被销毁
person3 = person1                         // 目前该实例共有三个强引用

person1 = nil
person2 = nil                             // 因为还有一个强引用,实例不会被销毁
person3 = nil                             // 最后一个强引用被断开,ARC会销毁它


// 类实例之间的循环引用:两个实例互相持有对方的强引用
class People {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?              // 人住的公寓属性
    deinit {
        print("People被销毁")
    }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: People?                   // 公寓中的人的属性
    deinit {
        print("Apartment被销毁")
    }
}

var people1: People? = People(name: "Dariel")  // 定义两个实例变量
var apartment1: Apartment? = Apartment(unit: "4A")

people1!.apartment = apartment1           // 两者相互引用
apartment1?.tenant = people1              // 而且彼此都是强引用

people1 = nil
apartment1 = nil                          // 两个引用都置为nil了,但实例并没有销毁


// 解决循环引用的三种方法
// 实例之间的循环强引用的解决办法:弱引用和无主引用,对于在生命周期会变为nil的实例使用弱引用,对于初始化后不能被赋值为nil的实例,使用无主引用
// 弱引用:在声明属性前面加关键字weak
class OtherPeople {
    let name: String
    init(name: String) { self.name = name }
    var apartment: OtherApartment?        // 人住的公寓属性
    deinit { print("\(name)被销毁") }
}

class OtherApartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: OtherPeople?         // 加一个weak关键字,表示该变量为弱引用
    deinit { print("\(unit)被销毁") }
}

var otherPeople1: OtherPeople? = OtherPeople(name: "Dariel") // 定义两个实例变量
var otherApartment1: OtherApartment? = OtherApartment(unit: "4A")

otherPeople1!.apartment = otherApartment1 // 两者相互引用
otherApartment1?.tenant = otherPeople1    // 但tenant是弱引用
otherPeople1 = nil
otherApartment1 = nil                     // 实例被销毁,deinit中都会打印销毁的信息

// 无主引用:在声明属性前面加关键字unowned
class Dog {
    let name: String
    var food: Food?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name)被销毁") }
}
class Food {
    let number: Int
    unowned var owner: Dog               // owner是一个无主引用
    init(number: Int, owner: Dog) {
        self.number = number
        self.owner = owner
    }
    deinit { print("食物被销毁") }
}

var dog1: Dog? = Dog(name: "Kate")
dog1?.food = Food(number: 6, owner: dog1!) // dog强引用food,而food对dog是无主引用

dog1 = nil                                 // 这样就可以同时销毁两个实例了

// 如果互相引用的两个属性都为可选类型,也就是可以为nil,比较适合用弱引用来解决.如果两个互相引用的属性,只有一个类的属性为可选类型,那么适合用无主引用来解决.那么,如果两个属性都不能是可选类型呢?一个类使用无主属性,另一个类使用隐式解析可选属性.
class Country {
    let name: String
    // City后加!为隐式解析可选属性,类似可选类型,capitalCity属性的默认值为nil
    var capitalCity: City!                // 初始化完成后可以当非可选类型使用
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
    deinit { print("Country实例被销毁") }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
    deinit { print("City实例被销毁") }
}

// 这样一条语句就能够创建两个实例
var country: Country? = Country(name: "China", capitalName: "HangZhou")
print(country!.name)                        // China
print(country!.capitalCity.name)            // HangZhou
country = nil                               // 同时销毁两个实例



// 闭包也是引用类型,也会引起的循环强引用
class Element {
    let name: String
    let text: String?
    
    lazy var group:() -> String = {        // 相当于一个没有参数返回string的函数
        [unowned self] in                   // 定义捕获列表,将self变为无主引用
        if let text = self.text {           // 解包
            return "\(self.name), \(text)"
        }else {
            return "\(self.name)"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    deinit { print("\(name)被销毁") }
}

var element1: Element? = Element(name: "Alex", text: "Hello")
print(element1!.group())                     // Alex, Hello,闭包与实例相互引用

element1 = nil                               // self为无主引用,实例能被销毁
