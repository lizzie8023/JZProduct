//
//  RootTabBarController.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/7/11.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import UIKit
import MBProgressHUD

class RootTabBarController: UITabBarController, ViewControllerCreatableType {

    static var storyboardIdentifier: String {
        return "Main"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return selectedViewController?.preferredStatusBarStyle ?? .default
    }
    
    deinit {
        Log.info("[Release]: " + String(describing: self.classForCoder))
    }

}
