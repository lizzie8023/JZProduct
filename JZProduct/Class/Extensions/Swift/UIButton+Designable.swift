//
//  UIButton+Designable.swift
//  Thingyan
//
//  Created by Jeff Zhao on 15/11/2.
//  Copyright © 2015年 Phantomex. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// Normal
    @IBInspectable var title_n_h: String? {
        get {
            return title(for: [.normal,.highlighted])
        }
        set {
            setTitle(newValue, for: [.normal,.highlighted])
        }
    }
    
    @IBInspectable var titleColor_n_h: UIColor? {
        get {
            return titleColor(for: [.normal, .highlighted])
        }
        set {
            setTitleColor(newValue, for: [.normal,.highlighted])
        }
    }
    
    @IBInspectable var image_n_h: UIImage? {
        get {
            return image(for: [.normal,.highlighted])
        }
        set {
            setImage(newValue, for: [.normal,.highlighted])
        }
    }
    
    @IBInspectable var backImage_n_h: UIImage? {
        get {
            return backgroundImage(for: [.normal,.highlighted])
        }
        set {
            setBackgroundImage(newValue, for: [.normal,.highlighted])
        }
    }
    
    /// Selected
    @IBInspectable var title_s_h: String? {
        get {
            return title(for: [.selected,.highlighted])
        }
        set {
            setTitle(newValue, for: [.selected,.highlighted])
        }
    }
    
    @IBInspectable var titleColor_s_h: UIColor? {
        get {
            return titleColor(for: [.selected,.highlighted])
        }
        set {
            setTitleColor(newValue, for: [.selected,.highlighted])
        }
    }
    
    @IBInspectable var image_s_h: UIImage? {
        get {
            return image(for: [.selected,.highlighted])
        }
        set {
            setImage(newValue, for: [.selected,.highlighted])
        }
    }
    
    @IBInspectable var backImage_s_h: UIImage? {
        get {
            return backgroundImage(for: [.selected,.highlighted])
        }
        set {
            setBackgroundImage(newValue, for: [.selected,.highlighted])
        }
    }
}
