//
//  APIManagerProtocol.swift
//  JZNetworking
//
//  Created by JeffZhao on 16/9/20.
//  Copyright © 2016年 JeffZhao. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private let Secret = "123"

public protocol APIManagerProtocol: Alamofire.URLConvertible, Alamofire.URLRequestConvertible {
    
    static var BaseWebURL: String { set get }
    
    static var BaseAPIURL: String { set get }

    var path: String { get }
    
    var method: Alamofire.HTTPMethod { get }
    
    var parameters: Alamofire.Parameters { get }
    
    var encoding: Alamofire.ParameterEncoding { get }
    
    var header: Alamofire.HTTPHeaders { get }
    
    var photoData: Data? { get }
    
    func validated() -> String
}

public extension APIManagerProtocol {
    
    /// WebURL
    static func WebAbsoluteURL(_ path: String) -> URL? {
        return URL(string: BaseWebURL)?.appendingPathComponent(path)
    }
    
    /// APIURL
    static func APIAbsoluteURL(_ path: String) -> URL? {
        return URL(string: BaseAPIURL)?.appendingPathComponent(path)
    }
    
    var header: Alamofire.HTTPHeaders {
        var headers = SessionManager.defaultHTTPHeaders
        headers.updateValue("application/json", forKey: "Accept")
        headers.updateValue(UserAgent, forKey: "UserAgent")
        return headers
    }
    
    var encoding: Alamofire.ParameterEncoding {
        return [HTTPMethod.post, .put, .patch].contains(method) ? URLEncoding.httpBody : URLEncoding.default
    }
    
    var encryptedParamters: Alamofire.Parameters {
        guard method == .post else {
            //GET 方法添加extra_info参数
            var parameters = self.parameters
            parameters.updateValue(ExtraInfo().jsonString, forKey: "extra_info")
            return parameters
        }
        var parameters = self.parameters
        let version = Bundle.appVersion
        let params = JSON(parameters).map{ $0 + "=" + $1.stringValue }.sorted().reduce("", { $0.isEmpty ? $1 : $0 + "&" + $1 })
        let signString = params + version + Secret
        parameters.updateValue(signString.md5, forKey: "sign")
        return parameters
    }
    
    func validated() -> String {
        return ""
    }

}

extension Alamofire.URLConvertible where Self: APIManagerProtocol {
    
    public func asURL() throws -> URL {
        guard let url = Self.APIAbsoluteURL(path) else { throw AFError.invalidURL(url: self) }
        return url
    }
}

extension Alamofire.URLRequestConvertible where Self: APIManagerProtocol {
    
    public func asURLRequest() throws -> URLRequest {
        let url = try asURL()
        let request = try URLRequest(url: url, method: method, headers: header)
        return try encoding.encode(request, with: encryptedParamters)
    }
}
