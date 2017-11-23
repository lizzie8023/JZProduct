//
//  APIService+DNS.swift
//  JZKit
//
//  Created by JeffZhao on 16/9/27.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire

/// dns解析错误时，更新ip地址
enum DNSRouter {
    case webDNS
    case apiDNS
}

/// http://119.29.29.29/d?dn=web.zhaojianfei.com
extension DNSRouter: APIManagerProtocol {
    
    public var photoData: Data? {
        return nil
    }

    public var parameters: Parameters {
        switch self {
        case .apiDNS:
            return ["dn": DNSRouter.BaseAPIURL.jz.remove("http://")]
        case .webDNS:
            return ["dn": DNSRouter.BaseWebURL.jz.remove("http://")]
        }
    }

    public var method: HTTPMethod {
        return .get
    }

    public var path: String {
        return ""
    }

    public static var BaseWebURL = "http://119.29.29.29/d"
    
    public static var BaseAPIURL = "http://119.29.29.29/d"
    
}
