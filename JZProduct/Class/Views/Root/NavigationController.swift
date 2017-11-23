//
//  NavigationController.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/7/11.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            return false
        }
        return true
    }
}
