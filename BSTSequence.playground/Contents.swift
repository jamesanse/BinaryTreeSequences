//: Playground - noun: a place where people can play

import Foundation

class TreeNode {
     var val: Int
     var left: TreeNode?
     var right: TreeNode?
     init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}

class TreeIterator: IteratorProtocol {
    private var res = [TreeNode]()
    var node: TreeNode
    func next() -> TreeNode? {
        let first = res.first
        if !res.isEmpty {
            res.remove(at: 0)
        }
        return first
    }
    init(root: TreeNode) {
        node = root
        var BSTQueue = [TreeNode]()
        BSTQueue.insert(node, at: 0)
        while !BSTQueue.isEmpty {
            if let lastNode = BSTQueue.popLast() {
                res.append(lastNode)
                if let left = lastNode.left {
                    BSTQueue.insert(left, at: 0)
                }
                if let right = lastNode.right {
                    BSTQueue.insert(right, at: 0)
                }
            }
        }
    }
    
}

extension TreeNode: Sequence {
    func makeIterator() -> TreeIterator {
        return TreeIterator(root: self)
    }
}

var nodes = TreeNode(10)
var leftNode = TreeNode(5)
var rightNode = TreeNode(10)
nodes.left = leftNode
nodes.right = rightNode

leftNode.left = TreeNode(2)
leftNode.right = TreeNode(20)
rightNode.left = TreeNode(9)
rightNode.right = TreeNode(25)


for node in nodes {
   print(node.val)
}
