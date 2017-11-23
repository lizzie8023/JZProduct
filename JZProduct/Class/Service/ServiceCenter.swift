//
//  Service.swift
//  UFace
//
//  Created by JeffZhao on 2017/5/11.
//  Copyright © 2017年 JeffZhao. All rights reserved.
//

import Foundation
import RxSwift

protocol ServiceType {
    init()
}

extension ServiceType {
    static func clean() {
        ServiceCenter.default.removeService(self)
    }
}

class ServiceCenter {
    
    private let _lock = NSRecursiveLock()
    
    private var _serviceMap = [String: Any]()
    
    static let `default` = ServiceCenter()
    
    func service<T: ServiceType>(_ classType: T.Type) -> T {
        let iden = String(describing: classType)
        _lock.lock(); defer { _lock.unlock() }
        if let obj = _serviceMap[iden] as? T {
            return obj
        }
        let obj = classType.init()
        _serviceMap[iden] = obj
        return obj
    }
    
    func removeService<T: ServiceType>(_ classType: T.Type) {
        let iden = String(describing: classType)
        _lock.lock(); defer { _lock.unlock() }
        _serviceMap.removeValue(forKey: iden)
    }
    
}


