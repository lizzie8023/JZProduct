//
//  Array+Ext.swift
//  JeffZhao
//
//  Created by Jeff Zhao on 15/8/27.
//  Copyright © 2015 JZ Studio. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    
    @discardableResult
    public mutating func replace(_ newElement: Element) -> Element? {
        if let index = self.index(of: newElement) {
            let element = self[index]
            self[index] = newElement
            return element
        } else {
            return nil
        }
    }

    @discardableResult
    public mutating func remove(_ newElement: Element) -> Element? {
        if let index = self.index(of: newElement) {
            return self.remove(at: index)
        } else {
            return nil
        }
    }
}

extension Array {
    
    @discardableResult
    public mutating func replace(_ newElement: Element, predicate: (Element) -> Bool) -> Element? {
        if let index = self.index(where: predicate) {
            let element = self[index]
            self[index] = newElement
            return element
        } else {
            return nil
        }
    }
    
    @discardableResult
    public mutating func remove(predicate: (Element) -> Bool) -> Element? {
        if let index = self.index(where: predicate) {
            return self.remove(at: index)
        } else {
            return nil
        }
    }
}

extension Collection {
    
    /// 带参数遍历
    func forEachWithIndex(_ body: (Int, Self.Iterator.Element) throws -> ()) rethrows {
        return try enumerated().forEach(body)
    }
    
    func mapWithIndex<T>(_ transform: (Int, Self.Iterator.Element) throws -> T) rethrows -> [T] {
        return try enumerated().map(transform)
    }
    
    /// Use as
    ///
    ///      let num = [1,2,3,4,5]
    ///      num.forEachWithIndexInterruptible{
    ///        if $1 > 3 { $2 = true }
    ///        print($0,$1)
    ///      }
    func forEachWithIndexInterruptible(_ body: ((Self.Iterator.Element, Int, inout Bool) -> Void)) {
        var stop = false
        let enumerate = self.enumerated()
        for (index,value) in enumerate {
            if stop { break }
            body(value,index,&stop)
        }
    }
    
    /// Use as
    ///
    ///      let num = [1,2,3,4,5]
    ///      num.forEachInterruptible{
    ///        if $0 > 3 { $1 = true }
    ///        print($0)
    ///      }
    func forEachInterruptible(_ body: ((Self.Iterator.Element, inout Bool) -> Void)) {
        var stop = false
        for value in self {
            if stop { break }
            body(value,&stop)
        }
    }
}
