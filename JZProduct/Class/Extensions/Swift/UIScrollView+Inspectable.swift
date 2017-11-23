//
//  UIScrollView+Inspectable.swift
//  JeffZhao
//
//  Created by Jeff Zhao on 15/5/26.
//  Copyright © 2015 JZ Studio. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    @IBInspectable
    public var contentInsetString: String {
        get {
            return NSStringFromUIEdgeInsets(contentInset)
        }
        set {
            contentInset = UIEdgeInsetsFromString(newValue)
        }
    }

}
