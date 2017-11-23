//
//  UIViewController+Hierarchy.swift
//  JeffZhao
//
//  Created by Jeff Zhao on 15/4/16.
//  Copyright © 2015 JZ Studio. All rights reserved.
//

import Foundation
import UIKit
import JZSwiftWarpper

extension JZStudio where Base: UIViewController {
    
    func childViewController(prefix: String) -> UIViewController? {
        return base.childViewControllers.filter { vc in
            vc.title?.hasPrefix(prefix) ?? false
            }.first
    }
    
    func childViewController<T: UIViewController>(type: T) -> UIViewController? {
        return base.childViewControllers.filter{ $0 is T }.first
    }
    
    func nextViewController() -> UIViewController? {
        if let presented = base.presentedViewController {
            return presented
        } else if let vcs = base.navigationController?.viewControllers,
            let index = vcs.index(of: base), index + 1 < vcs.count {
            return vcs[index + 1]
        } else {
            return nil
        }
    }
    
    func backViewController() -> UIViewController? {
        if let vcs = base.navigationController?.viewControllers,
            let index = vcs.index(of: base), index - 1 >= 0 {
            return vcs[index - 1]
        } else if let presenting = base.presentingViewController {
            return presenting
        } else {
            return nil
        }
    }
}
