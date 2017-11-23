//
//  Settings.swift
//  JeffZhao
//
//  Created by Jeff Zhao on 15/4/12.
//  Copyright © 2015 JZ Studio. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger

// MARK: - Typealias
typealias J_IDTYPE = CUnsignedLongLong

// MARK: Server API

#if DEBUG
let APIDomain = "http://api.zhaojianfei.com"
let WebDomain = "http://web.zhaojianfei.com"
let AssetsDomain = APIDomain
#elseif PUBLIC
let APIDomain = "http://api.zhaojianfei.com"
let WebDomain = "http://web.zhaojianfei.com"
let AssetsDomain = WebDomain
#else
let APIDomain = "http://api.zhaojianfei.com"
let WebDomain = "http://web.zhaojianfei.com"
let AssetsDomain = WebDomain
#endif

let WechatAppID = "XXXXXXXXXXXX"
let WechatAppSecret = "XXXXXXXXXXXXX"
let BuglyAppID = "XXXXXXXXXXX"

//SinaWeibo key
let SinaWeiboAppKey = "XXXXXXXXXX"
let SinaWeiboRedirectURI = "XXXXXXXXXXXXXX"

// MARK: UI
struct Palette {

    /// Text
    
}


let DefaultAnimationDuration = 0.3

// MARK: Segue

/// Segue Identifier与Enum case名称一致
///
/// 命名规则为 `'segue类型'+'vc名称'`，如
/// - pushDestination
/// - modalSignIn
public enum SegueID: String {
    case none = ""
}

func == (lhs: String?, rhs: SegueID) -> Bool {
    return lhs == rhs.rawValue
}

let Log: XCGLogger = {
    return XCGLogger.default
}()
