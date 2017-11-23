//
//  APIService+DNS.swift
//  JZKit
//
//  Created by JeffZhao on 16/9/27.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire

let DefaultActiveTime: Int = 300000;

/// 用户关系
///
/// - normal: 默认关系
/// - pairing: 正在配对
/// - paired: 配对成功
enum RelationStatus: Int {
    case normal = 0
    case pairing = 1
    case paired = 2
    
    var next: RelationStatus {
        switch self {
        case .normal:
            return .pairing
        case .pairing:
            return .paired
        case .paired:
            return .paired
        }
    }
}

struct APIPage {
    
    typealias IntegerLiteralType = Int

    let cursor: String
    let count: Int
    
    init(_ cursor: String) {
        self.init(cursor: cursor, count: 20)
    }
    
    init(cursor: String, count: Int) {
        self.cursor = cursor
        self.count = count
    }
    
    var param: [String: Any] {
        return ["cursor": cursor, "count": count]
    }
}

enum OrderType: String {
    /// 默认
    case normal
    /// 升序
    case asc
    /// 降序
    case desc
    var next: OrderType {
        switch self {
        case .normal:
            return .asc
        case .asc:
            return .desc
        case .desc:
            return .normal
        }
    }
    var param: (String) -> [String: Any] {
        return { key in
            switch self {
            case .normal:
                return [:]
            default:
                return [key: self.rawValue]
            }
        }
    }
}

/// API请求接口
enum APIManager {
    
    /// 占位
    case none
    /// 用户登录
    case userLogin(userName: String, password: String)
    /// 刷新token
    case refreshToken(token: String)
}

extension APIManager: APIManagerProtocol {
    
    var photoData: Data? {
        switch self {
        default:
            return nil
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        var headers = SessionManager.defaultHTTPHeaders
        headers.updateValue("application/json", forKey: "Accept")
        headers.updateValue(UserAgent, forKey: "User-Agent")
        /// 刷新token时不能带
        switch self {
        case .refreshToken,
             .userLogin:
            headers.removeValue(forKey: "Authorization")
        default:
            break
        }
        /// 未登录时不能带
        if !ServiceCenter.auth.currentUserToken.isEmpty {
            headers.updateValue("Bearer \(ServiceCenter.auth.currentUserToken)", forKey: "Authorization")
        }
        return headers
    }
    
    var parameters: Alamofire.Parameters {
        return _parameters
    }

    var _parameters: Alamofire.Parameters {
        switch self {
        case let .userLogin(username, password):
            return ["username": username, "password": password]
        case let .refreshToken(token):
            return ["token": token]
        
        default:
            return [:]
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .userLogin:
            return .post
        default:
            return .get
        }
    }

    var path: String {
        return _path
    }

    static var BaseWebURL = WebDomain
    
    static var BaseAPIURL = APIDomain
    
    /// 验证参数是否正确
    ///
    /// - Returns: 错误描述 无错误时返回空值
    func validated() -> String {
        switch self {
        case let .userLogin(username,password):
            return username.isEmpty ? "请输入正确的用户名" : (password.isEmpty ? "请输入密码" : "")
        case let .refreshToken(token):
            return token.isEmpty ? "刷新Token时不能使用空Token" : ""
        default:
            return ""
        }
    }
    
    private var _path: String {
        switch self {
        case .userLogin:
            return "xxxxxxxx/login/"
        case .refreshToken:
            return "xxxxxxx/api_token_refresh/"
        default:
            return ""
        }
    }
}

