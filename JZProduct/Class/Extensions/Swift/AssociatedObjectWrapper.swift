//
//  AssociatedObjectWrapper.swift
//  
//
//  Created by JeffZhao on 2016/10/13.
//  Copyright © 2016年 JeffZhao. All rights reserved.
//

import Foundation
import ObjectiveC
import JZSwiftWarpper

extension JZStudio where Base: NSObject {
    
    func setAssociatedObject<T>(key: UnsafeRawPointer, value: T, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.base.setAssociatedObject(key: key, value: value, policy: policy)
    }
    
    @discardableResult
    func getAssociatedObject<T>(key: UnsafeRawPointer, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC, initialiser: (() -> T)? = nil) -> T? {
        return self.base.getAssociatedObject(key: key, policy: policy, initialiser: initialiser)
    }
}

/// swift3完善了与oc数据类型的桥接，Int,() -> ()，struct,enum均能直接使用运行时填加

extension NSObject {
    
    /// objc_setAssociatedObject
    ///
    ///     var a = 123
    ///     setAssociatedObject(key: &a, value: a, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    ///
    public func setAssociatedObject<T>(key: UnsafeRawPointer, value: T, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, key, value, policy)
    }
    
    /// objc_setAssociatedObject
    ///
    ///     var a = 123
    ///     /// 直接取值
    ///     getAssociatedObject(key: &a)
    ///     /// 取不到值时赋值
    ///     getAssociatedObject(key: &a, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC, initialiser: {
    ///         return 456
    ///     })
    ///
    @discardableResult
    public func getAssociatedObject<T>(key: UnsafeRawPointer, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC, initialiser: (() -> T)? = nil) -> T? {
        if let value = objc_getAssociatedObject(self, key) as? T {
            return value
        } else if let initialiser = initialiser {
            let value = initialiser()
            setAssociatedObject(key: key, value: value, policy: policy)
            return value
        }
        return nil
    }
    
}

public func setAssociatedObject<T>(object: AnyObject, value: T, key associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
    objc_setAssociatedObject(object, associativeKey, value,  policy)
}

public func getAssociatedObject<T>(object: AnyObject, key associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC, initialiser: (() -> T)? = nil) -> T? {
    if let v = objc_getAssociatedObject(object, associativeKey) as? T {
        return v
    } else if let initialiser = initialiser {
        let obj = initialiser()
        setAssociatedObject(object: object, value: obj, key: associativeKey, policy: policy)
        return obj
    } else {
        return nil
    }
}

