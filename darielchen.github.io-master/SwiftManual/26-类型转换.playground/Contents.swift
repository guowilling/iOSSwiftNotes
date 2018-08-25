//: Playground - noun: a place where people can play

import UIKit

// 类型转换: 使用is和as来检查值得类型和转换类型
class Media {                             // 定义一个基类
    var name: String                      // 提供一个name属性
    init(name: String) {
        self.name = name
    }
}
class Movie: Media {
    var director: String                  // 在继承基类的基础上多了一个导演属性
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}
class Song: Media {
    var artist: String                    // 在继承基类的基础上多了一个艺术家属性
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [Movie(name: "AF", director: "Aedc"), // library的类型为[Media]类型
                Song(name: "CV", artist: "Lona"),
                Song(name: "CV", artist: "Lona")]
let item1 = library[0]                    // item1的类型为父类Media,而不是Movie


// 类型检查: 使用类型检查符(is)来检查一个实例是否属于特定子类型,若是则返回true否则返回false
var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {                   // is用来检查item是否属于Media的子类Movie
        movieCount += 1
    }else if item is Song {
        songCount += 1
    }
}
print("movieCount:\(movieCount), songCount:\(songCount)") // movieCount:1, songCount:2



// 向下类型转换:通过类型转换符(as?或as!)将某个类型转换为实际的子类型
for item in library {
    if let movie = item as? Movie { // 不确定向下类型转换是否可以成功用as?,此时会返回一个可选值
        print("director:\(movie.director)")
    } else if let song = item as? Song { // 使用可选绑定来解包
        print("artist:\(song.artist)")
    }
}
// 如果确定类型转换会成功可以使用强制类型转换(as!),但如果转换失败会报错


// 使用Any和AnyObject来进行类型转换. AnyObject: 表示任何类型的实例. Any: 表示任何类型
// 定义一个AnyObject类型的数组,并设置3个Movie类型的实例
let objects: [AnyObject] = [Movie(name: "AF", director: "Aedc"),
                            Movie(name: "AF", director: "Aedc"),
                            Movie(name: "AF", director: "Aedc")]
for object in objects {
    let movie = object as! Movie         // 使用as!强制类型转换并解包Movie类型
    print(movie.director)
}

for object in objects as! [Movie] {       // 或者可以直接将objects转化成[Movie]类型
    print(object.director)
}

var things = [Any]()                      // 定义一个可以存储任何类型的数组
things.append(2)                          // 添加一个Int类型的整数
things.append(3.4)                        // Double类型
things.append("A")                        // String类型
things.append((2, 3))                     // 元组类型
things.append({ (name: String) -> String in "Hello, \(name)"}) //闭包类型

for thing in things {
    switch thing {
    case let intValue as Int:             // 使用as来转化成具体类型
        print(intValue)
    case let doubleValue as Double:
        print(doubleValue)
    case let stringValue as String:
        print(stringValue)
    case let (x, y) as (Int, Int):
        print("\(x),\(y)")
    case let stringConverter as (String) -> String:
        print(stringConverter("Lily"))
    default:
        print("Something else")
    }
}