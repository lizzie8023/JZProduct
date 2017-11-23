//
//  SignInView.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/7/11.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import Foundation

class SignInTextField: BottomLineTextField {
    override func setup() {
        super.setup()
        self.jz.setPlaceholderColor(UIColor.red)
        tintColor = UIColor.red
    }
}
