//
//  Extension+Init.swift
//  JeffZhao
//
//  Created by Jeff Zhao on 15/4/16.
//  Copyright © 2015 JZ Studio. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    convenience init(style: UIAlertControllerStyle, title: String?, message: String?, actions: [UIAlertAction] = []) {
        self.init(title: title, message: message, preferredStyle: style)
        for action in actions {
            self.addAction(action)
        }
    }
    
}

extension UIColor {
    
    convenience init(_ r: Int, _ g: Int, _ b: Int, _ a: Double = 1.0) {
        self.init(red: CGFloat(Double(r)/255.0),
                  green: CGFloat(Double(g)/255.0),
                  blue: CGFloat(Double(b)/255.0),
                  alpha: CGFloat(a))
    }
    
    convenience init(r: Int, g: Int, b: Int, a: Double = 1.0) {
        self.init(red: CGFloat(Double(r)/255.0),
            green: CGFloat(Double(g)/255.0),
            blue: CGFloat(Double(b)/255.0),
            alpha: CGFloat(a))
    }

    convenience init(hex: Int) {
        let components = (
            R: (hex >> 16) & 0xff,
            G: (hex >> 08) & 0xff,
            B: (hex >> 00) & 0xff
        )
        self.init(r: components.R, g: components.G, b: components.B, a: 1)
    }
    
    var hex: String {
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255) << 16 | (Int)(g*255) << 08 | (Int)(b*255) << 00
        return String(rgb, radix: 16)
    }
}
