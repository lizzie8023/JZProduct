//
//  ClassIdentify.swift
//  Pods
//
//  Created by JeffZhao on 16/9/23.
//
//

import Foundation

public protocol ClassIdentify: class {
    
    static var reuseIdentifier: String { get }
}

extension ClassIdentify {
    
    public static var reuseIdentifier: String {
        
        return String(describing: self)
    }
}
