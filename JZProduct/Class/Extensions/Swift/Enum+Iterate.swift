//
//  Enum+Iterate.swift
//  WK
//
//  Created by JeffZhao on 16/2/24.
//  Copyright © 2016年 JeffZhao. All rights reserved.
//

import Foundation

class EnumGenerator<Enum : Hashable> : IteratorProtocol {
    var rawEnum = 0
    var done = false
    
    func next() -> Enum? {
        if done { return nil }
        
        let enumCase = withUnsafePointer(to: &rawEnum) { UnsafeRawPointer($0).load(as: Enum.self) }
        if enumCase.hashValue == rawEnum {
            rawEnum += 1
            return enumCase
        } else {
            done = true
            return nil
        }
    }
}

class SingleEnumGenerator<Enum : Hashable> : EnumGenerator<Enum> {
    override func next() -> Enum? {
        return done ? nil : { done = true; return unsafeBitCast((), to: Enum.self) }()
    }
}

struct EnumSequence<Enum : Hashable> : Sequence {
    func makeIterator() -> EnumGenerator<Enum> {
        switch MemoryLayout<Enum>.size {
        case 0:
            return SingleEnumGenerator()
        default:
            return EnumGenerator()
        }
    }
}

protocol EnumCollection : Hashable {

}

extension EnumCollection {
    static func cases() -> EnumSequence<Self> {
        return EnumSequence()
    }
}

extension Hashable {
    /// IterateEnum
    ///
    ///     enum E {
    ///         case A, B, C
    ///     }
    ///
    ///     func test() {
    ///         for i in E.enumCases() {
    ///             print(i)
    ///         }
    ///     }
    ///     //A,B,C
    ///
    static func enumCases() -> EnumSequence<Self> {
        return EnumSequence()
    }
}
