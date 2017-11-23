//
//  Label.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/9/12.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import Foundation
import UIKit

class Label: UILabel {
    
    var textInsets = UIEdgeInsets.zero
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
    
    override var intrinsicContentSize: CGSize  {
        var size = super.intrinsicContentSize
        size.width += textInsets.left + textInsets.right
        size.height += textInsets.top + textInsets.bottom
        return size
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + textInsets.left + textInsets.right
        let heigth = superSizeThatFits.height + textInsets.top + textInsets.bottom
        return CGSize(width: width, height: heigth)
    }
    
}
