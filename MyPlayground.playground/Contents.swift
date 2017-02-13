//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

struct Message {
    let user: String
    let message: String
}

var messages = [Message(user:"a",message:"how are you"),Message(user:"a",message:"i am fine"),Message(user:"b",message:"i am good"), Message(user:"b",message:"and you?"),Message(user:"a",message:"not bad")]


func groupByUser(_ messages: [Message]) -> [[Message]] {
    guard let firstMessage = messages.first, messages.count > 1 else {
        return [messages]
    }
    
    let sameUserTest: (Message) -> Bool = {
        $0.user == firstMessage.user
    }
    let firstGroup = Array(messages.prefix(while: sameUserTest))
    let rest = Array(messages.drop(while: sameUserTest))
    
    return [Array(firstGroup)] + groupByUser(Array(rest))
}

随着Xcode 8.3 的发布，Swift2.3 将推出舞台。 还没有升级到Swift 3.0的朋友可以现在考虑升级了。
Xcode 8.3 推出的同时，Swift 将迎来一个小版本，Swift 3.1. 让我们看看有什么新的东西可以期待。


1   Extension 可以用实类进行约束

如果我们要写一个Array 的extension, 而且保证 extension 里面的function 只能在Array 包含Int 的时候才能叫，在3.1 之前是没有办法做到的。最接近的代码如下

extension Array where Element: Comparable {
    func lessThanFirst() -> [Element] {
        return self.filter { $0 < first }
    }
}

let items = [5, 6, 10, 4, 110, 3].lessThanFirst()

上面的代码表示当Array 的内容都是 Comparable 的情况下，lessThanFirst() 是可以使用的。 而且 Int 类型正好是 Comparable. 但是上面的代码让所有的 Comparable, 例如 Float, Double 都可以使用 lessThanFirst()。

如果一定要保证Int型的需求的话，我们需要给Int 型附上一个自定义的Protocol。代码如下

protocol IntOnly: Comparable { }

extension Int : IntOnly {}

extension Array where Element: IntOnly{
    func lessThanFirst() -> [Element] {
        guard let first = self.first else { return [] }
        return self.filter { $0 < first }
    }
}

let items = [5, 6, 10, 4, 110, 3].lessThanFirst()


在Swift 3.1，代码就很简单了。

extension Array where Element == Int {
    func lessThanFirst() -> [Int] {
        guard let first = self.first else { return [] }
        return self.filter { $0 < first }
    }
}

let items = [5, 6, 10, 4, 110, 3].lessThanFirst()


2  Sequences 得到两个新的Function, prefix(while:) 和 drop(while:)

sequences 的主要类型有Array,Dictionary, Set 等

prefix(while:) 会轮询每一个item, 找到一个最长满足while 条件的段，案例如下




let names = ["Michael Jackson", "Michael Jordan", "Michael Caine", "Taylor Swift", "Adele Adkins", "Michael Douglas"]
let prefixed = names.prefix { $0.hasPrefix("Michael") }
print(prefixed)

得到的结果是["Michael Jackson", "Michael Jordan", "Michael Caine"]

drop(while:)则是相反的。它会轮询每一个item, 找到一个最长满足while 条件的段，然后把这一段之后的所有item 返回回来

let names = ["Michael Jackson", "Michael Jordan", "Michael Caine", "Taylor Swift", "Adele Adkins", "Michael Douglas"]
let dropped = names.drop { $0.hasPrefix("Michael") }
print(dropped)


得到的结果为["Taylor Swift", "Adele Adkins", "Michael Douglas"]

一个经典的使用案例

假设我们在写一个2人聊天应用，我们需要把两个人聊天记录做整理，例如





[a:"how are you"]

[a:"I am fine"]

[b:"I am good"]

[b: "And you?"]

[a:"not bad"]

struct Message {
    let user: String
    let message: String
}

var messages = [Message(user:"a",message:"how are you"),Message(user:"a",message:"i am fine"),Message(user:"b",message:"i am good"), Message(user:"b",message:"and you?"),Message(user:"a",message:"not bad")]

func groupByUser(_ messages: [Message]) -> [[Message]] {
    
    guard let firstMessage = messages.first, messages.count > 1 else {
        return [messages]
    }
    let sameUserTest: (Message) -> Bool = {
        $0.user == firstMessage.user
    }
    let firstGroup = Array(messages.prefix(while: sameUserTest))
    let rest = Array(messages.drop(while: sameUserTest))
    return [Array(firstGroup)] + groupByUser(Array(rest))
}












