//
//  APIService.swift
//  NetworkingType
//
//  Created by JeffZhao on 16/9/22.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire

public class APIService<T: APIManagerProtocol>: APIServiceProtocol {
    
    public typealias E = T
    
    public let manager = NetworkReachabilityManager(host: "www.baidu.com")
    
    public let maxMemoryCache = 20 * 1024 * 1024
    
    public let maxDiskCache = 100 * 1024 * 1024
    
    public let minMemoryCache = 4 * 1024 * 1024
    
    public func networkStatusChanged(status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        APILogger.info("\(status)")
    }
    
    public init() {
        configCache()
        configNetworkReachability()
    }
}
