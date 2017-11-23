//
//  TextField.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/7/11.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import Foundation
import UIKit

class TextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open func setup() {
    }
}

class BottomLineTextField: TextField {
    
    @IBInspectable var bottomLineHeight: CGFloat = 1
    @IBInspectable var bottomLineColor: UIColor = .white
    
    open override func setup() {
        super.setup()
        borderStyle = .none
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let bottomY = rect.maxY - bottomLineHeight / 2.0
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(bottomLineHeight)
        ctx?.setStrokeColor(bottomLineColor.cgColor)
        ctx?.move(to: CGPoint(x: 0, y: bottomY))
        ctx?.addLine(to: CGPoint(x: rect.width, y: bottomY))
        ctx?.strokePath()
    }
}
