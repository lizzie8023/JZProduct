//
//  main.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/7/10.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import Foundation

class Application: UIApplication {
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
    }
}

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc)),
    NSStringFromClass(Application.classForCoder()),
    NSStringFromClass(AppDelegate.classForCoder())
)
