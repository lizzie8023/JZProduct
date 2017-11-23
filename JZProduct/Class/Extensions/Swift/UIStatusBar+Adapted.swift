//
//  UIStatusBar+Adapted.swift
//  Pods
//
//  Created by JeffZhao on 2017/7/10.
//
//

import JZSwiftWarpper
import UIKit

extension JZStudio where Base: NSObject {
    
    var statusBar: UIView? {
        return UIApplication.shared.value(forKey: "statusBar") as? UIView
    }
    
    static var statusBar: UIView? {
        return UIApplication.shared.value(forKey: "statusBar") as? UIView
    }
    
}
