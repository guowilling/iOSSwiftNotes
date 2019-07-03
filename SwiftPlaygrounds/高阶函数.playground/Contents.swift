import UIKit

var str = "Hello, playground"

func addation(num1: Double, num2: Double) -> Double {
    return num1 + num2
}

func multiply(num1: Double, num2: Double) -> Double {
    return num1 * num2
}

func doMathOperation(operation: (_ x: Double, _ y: Double) -> Double, num1: Double, num2: Double) -> Double {
    return operation(num1, num2)
}

doMathOperation(operation: addation(num1:num2:), num1: 10, num2: 2)
doMathOperation(operation: multiply(num1:num2:), num1: 10, num2: 2)


func doArithmeticOperation(isMultiply: Bool) -> (Double, Double) -> Double {
    func addation(num1: Double, num2: Double) -> Double {
        return num1 + num2
    }
    
    func multiply(num1: Double, num2: Double) -> Double {
        return num1 * num2
    }
    
    return isMultiply ? multiply : addation
}

let operationToPerform1 = doArithmeticOperation(isMultiply: true)
let operationToPerform2 = doArithmeticOperation(isMultiply: false)

operationToPerform1(10, 2)
operationToPerform2(10, 2)

/// Map
/// Array
let arrayOfInts = [2, 3, 4, 5, 4, 3, 2]
var newArray: [Int] = []
for value in arrayOfInts { newArray.append(value * 10) }

//arrayOfInt.map(<#T##transform: (Int) throws -> T##(Int) throws -> T#>)
arrayOfInts.map({ (someInt: Int) -> Int in return someInt * 10 })
arrayOfInts.map({ (someInt: Int) in return someInt * 10 })
arrayOfInts.map({ someInt in return someInt * 10 })
arrayOfInts.map({ someInt in someInt * 10 })
arrayOfInts.map({ $0 * 10 })
arrayOfInts.map { $0 * 10 }


/// Dictionary
let dictOfBooks = ["harrypotter": 100.0, "junglebook": 100.0]
//dictOfBook.map(<#T##transform: ((key: String, value: Double)) throws -> T##((key: String, value: Double)) throws -> T#>)
let capitalizedBookNames = dictOfBooks.map { (key, value) in
    return key.capitalized
}

/// Set
let lengthInMeters: Set = [4.0, 6.2, 8.9]
let lengthInFeet = lengthInMeters.map { $0 * 3.2808 }

/// Map 获取 Index
let numbers = [1, 2, 4, 5]
let indexAndNum = numbers.enumerated().map { (index, num) in
    return "\(index): \(num)"
}

/// Filter
/// Array
let arrayOfIntegers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var evenArray = [Int]()
for integer in arrayOfIntegers {
    if integer % 2 == 0 {
        evenArray.append(integer)
    }
}
//arrayOfIntegers.filter(<#T##isIncluded: (Int) throws -> Bool##(Int) throws -> Bool#>)
arrayOfIntegers.filter({ (someInt: Int) -> Bool in return someInt % 2 == 0 })
arrayOfIntegers.filter({ (someInt: Int) in return someInt % 2 == 0 })
arrayOfIntegers.filter({ someInt in return someInt % 2 == 0 })
arrayOfIntegers.filter({ someInt in someInt % 2 == 0 })
arrayOfIntegers.filter({ $0 % 2 == 0 })
arrayOfIntegers.filter { $0 % 2 == 0 }

/// Dictionary
let dictOfBooks2 = ["harrypotter": 100.0, "junglebook": 1000.0]
//dictOfBooks2.filter(<#T##isIncluded: ((key: String, value: Double)) throws -> Bool##((key: String, value: Double)) throws -> Bool#>)
let results = dictOfBooks2.filter { (key, value) -> Bool in
    return value > 100
}
let results2 = dictOfBooks2.filter { $1 > 100 } // $0 为 key $1 为 value

/// Set
let lengthInMeters2: Set = [1, 2, 3, 4, 5, 6, 7, 8, 9]
let lengthInFeet2 = lengthInMeters.filter { $0 > 5 }

/// Reduce
/// Array
let numbers2 = [1, 2, 3, 4]
let numbersSum = numbers2.reduce(0) { (x, y)  in
    return x + y
}
//numbers.reduce(<#T##initialResult: Result##Result#>, <#T##nextPartialResult: (Result, Int) throws -> Result##(Result, Int) throws -> Result#>)
// 1.初始值为 0，x 为 0，y 为 1 -> 返回 x + y 。所以初始值或者结果变为 1。
// 2.初始值或者结果变为 1，x 为 1，y 为 2 -> 返回 x + y 。所以初始值或者结果变为 3。
// 3.初始值或者结果变为 3，x 为 3，y 为 3 -> 返回 x + y 。所以初始值或者结果变为 6。
// 4.初始值或者结果变为 6，x 为 6，y 为 4 -> 返回 x + y 。所以初始值或者结果变为 10。
numbers2.reduce(0, { (result: Int, nextItem: Int) -> Int in return result + nextItem })
numbers2.reduce(0, { (result: Int, nextItem: Int) in return result + nextItem })
numbers2.reduce(0, { (result, nextItem) in return result + nextItem })
numbers2.reduce(0, { (result, nextItem) in result + nextItem })
numbers2.reduce(0, { $0 + $1 })
numbers2.reduce(0) { $0 + $1 }

// numbers.reduce(0) { $0 * $1 } == numbers.reduce(0, *)

/// Dictionary
let dictOfBooks3 = ["harrypotter": 100.0, "junglebook": 1000.0]

let reduceResult1 = dictOfBooks3.reduce(10) { (result, tuple) in
    return result + tuple.value
}
let reduceResult2 = dictOfBooks3.reduce("Books are ") { (result, tuple) in
    return result + tuple.key + " "
}
// dictOfBooks3.reduce("Books are ") { $0 + $1.key + " " } // or $0 + $1.0 + " "

/// Set
let lengthInMeters3: Set = [4.0, 6.2, 8.9]
let reducedSet = lengthInMeters.reduce(0) { $0 + $1 }

/// FlatMap
/// Array
let flatMapInts = [[1,2,3], [4, 5, 6]]
let flatMapIntsResult = flatMapInts.flatMap { return $0 }
print(flatMapIntsResult)

/// Dictionary
let flatMapDicts = [["key1": 0, "key2": 1], ["key3": 3, "key4": 4]]
let flatMapDictsResult = flatMapDicts.flatMap { return $0 }
print(flatMapDictsResult)

/// CompactMap
let compactMapInts = [1, nil, 3, 4, nil]
let compactMapIntsResult = compactMapInts.compactMap{ $0 }
print(compactMapIntsResult)

let compactMapDict = ["key1": nil, "key2": 20]
let compactMapDictResult = compactMapDict.compactMap{ $0 }
print(compactMapDictResult)

let compactMapValuesDict = ["key1": nil, "key2": 20]
let compactMapValuesResult = compactMapValuesDict.compactMapValues{ $0 }
print(compactMapValuesResult)

let mapInts = [1, nil, 3, 4, nil]
let mapIntsResult = mapInts.map { $0 }
print(mapIntsResult)
