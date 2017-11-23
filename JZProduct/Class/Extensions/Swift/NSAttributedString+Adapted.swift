//
//  NSAttributedString+Adapted.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/9/11.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import Foundation
import JZSwiftWarpper

extension JZStudio where Base == NSAttributedString {
    
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = base.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = base.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.width)
    }
}
