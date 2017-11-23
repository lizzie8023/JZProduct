//
//  UITextField+Adapted.swift
//  Pods
//
//  Created by JeffZhao on 2017/7/10.
//
//

import Foundation
import UIKit
import JZSwiftWarpper

extension JZStudio where Base: UITextField {
    
    public func setPlaceholderColor(_ color: UIColor) {
        self.base.placeholderColor = color
    }
    
    public var placeholderColor: UIColor? {
        return self.base.placeholderColor
    }
    
    public func setPlaceholderFont(_ font: UIFont) {
        self.base.placeholderFont = font
    }
    
    public var placeholderFont: UIFont? {
        return self.base.placeholderFont
    }
}

extension UITextField {
    
    @IBInspectable
    public var placeholderColor: UIColor? {
        get {
            return __placeholderLabel?.textColor
        }
        set {
            __placeholderLabel?.textColor = newValue
        }
    }
    
    public var placeholderFont: UIFont? {
        get {
            return __placeholderLabel?.font
        }
        set {
            __placeholderLabel?.font = newValue
        }
    }
    
    var __placeholderLabel: UILabel? {
        let label = value(forKey: "placeholderLabel") as? UILabel
        if label == nil {
            print("[Error]: You should set placeholder before change placeholder text color")
        }
        return label
    }
}
