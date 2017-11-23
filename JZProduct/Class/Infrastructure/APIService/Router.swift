//
//  Log.swift
//  ViewModelKit
//
//  Created by JeffZhao on 16/9/24.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation
import XCGLogger
import RxSwift

let APILogger: XCGLogger = {
    let log = XCGLogger(identifier: "[NetworkingType]:", includeDefaultDestinations: false)    
    log.setup(level: .info, showThreadName: true, showLevel: true)
    return log
}()

public let UserDidLogOutObservable = PublishSubject<Bool>()
