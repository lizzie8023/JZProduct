//
//  Number+Ext.swift
//  Pods
//
//  Created by JeffZhao on 2017/7/10.
//
//

import Foundation

private let numberFormatter = NumberFormatter()

protocol JZNumberConvertible {
    func asNumber() -> NSNumber
}

extension JZNumberConvertible {
    /// 转换为String，并且不显示末尾无效的0
    var priceStringValue: String {
        numberFormatter.positiveFormat = "0.##"
        return numberFormatter.string(from: asNumber()) ?? "\(self)"
    }
}

extension Double: JZNumberConvertible {
    func asNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

extension Float: JZNumberConvertible {
    func asNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

extension Int: JZNumberConvertible {
    func asNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

