//
//  APIServiceProtocol.swift
//  JZNetworking
//
//  Created by JeffZhao on 16/9/21.
//  Copyright © 2016年 JeffZhao. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

public protocol APIServiceProtocol: class {
    
    associatedtype E: APIManagerProtocol
    
    var manager: NetworkReachabilityManager? { get }
    
    var maxMemoryCache: Int { get }
    
    var maxDiskCache: Int { get }
    
    var minMemoryCache: Int { get }
    
    func networkStatusChanged(status: NetworkReachabilityManager.NetworkReachabilityStatus)
}

extension APIServiceProtocol {
    
    func configCache() {
        let cache = URLCache.shared
        cache.memoryCapacity = maxMemoryCache
        cache.diskCapacity = maxDiskCache
        let aURLCacheMemoryMin = minMemoryCache
        NotificationCenter.default.addObserver(
            forName: .UIApplicationDidReceiveMemoryWarning,
            object: nil,
            queue: OperationQueue.main,
            using: { _ in
                let memoryCapacity = cache.memoryCapacity
                let newMemoryCapacity = max(Int(ceil(Double(memoryCapacity) * 0.8)), aURLCacheMemoryMin)
                cache.memoryCapacity = newMemoryCapacity
                APILogger.info("监测到内存警告，已经调整URLCache的大小到\(newMemoryCapacity)M")
            }
        )
    }
    
    func configNetworkReachability() {
        manager?.listener = { [weak self] in
            self?.networkStatusChanged(status: $0)
            APILogger.info("监测到网络状态的变化，当前网络连接方式为：\($0.rawValue)")
        }
        manager?.startListening()
    }
}

public extension APIServiceProtocol {
    
    public static func get(_ router: E, cache: Bool = false) -> Observable<JSON> {
        return connect(router, cache: cache)
    }
    
    public static func post(_ router: E) -> Observable<JSON> {
        return connect(router)
    }
    
    public static func delete(_ router: E) -> Observable<JSON> {
        return connect(router)
    }
    
    public static func upload(_ router: E, progress: @escaping Alamofire.Request.ProgressHandler) -> Observable<JSON> {
        return Observable.create { observer in
            var uploadRequest: UploadRequest?
            Alamofire.upload(
                multipartFormData: { formData in
                    if let photoData = router.photoData {
                        formData.append(photoData, withName: "photo.jpg", mimeType: "image/jpeg")
                    }
                },
                with: router,
                encodingCompletion: { result in
                    switch result {
                    case let .success(request, _, _):
                        uploadRequest = request
                        request.uploadProgress(closure: progress)
                            .response { response in
                                switch response.result {
                                case let .success(json):
                                    observer.onNext(json)
                                    observer.onCompleted()
                                case let .failure(error):
                                    observer.onError(error)
                                }
                        }
                    case let .failure(error):
                        observer.onError(error)
                    }
                }
            )
            return Disposables.create{
                if uploadRequest?.task?.state == .running {
                    uploadRequest?.cancel()
                    APILogger.info("uploadRequest canceled")
                }
            }
        }
    }
    
    private static func connect(_ router: E, cache: Bool = false) -> Observable<JSON> {
        let observableRequest: Observable<JSON> = Observable.create { observer in
            let validated = router.validated()
            if !validated.isEmpty {
                observer.onError(validated)
                return Disposables.create()
            } else {
                let request = Alamofire.request(router, method: router.method, parameters: router.encryptedParamters, encoding: router.encoding, headers: router.header).response{ response in
                    switch response.result {
                    case let .success(json):
                        observer.onNext(json)
                        observer.onCompleted()
                    case let .failure(error):
                        observer.onError(error)
                    }
                }
                return Disposables.create {
                    if request.task?.state == .running {
                        request.cancel()
                        APILogger.info("request canceled")
                    }
                }
            }
        }
        .do(
            onError: {
                if let apiError = $0 as? APIError {
                    if apiError.code == .invalidToken || apiError.code == .refreshTokenFailed {
                        UserDidLogOutObservable.onNext(true)
                    } else {
                        /// ...
                    }
                } else {
                    /// ...
                }
            }
        )
        .retryWhen{ errors in
            return errors.flatMap { err -> Observable<()> in
                if let apiError = err as? APIError {
                    if apiError.code == .needRefreshToken {
                        Log.info("用户Token过期，自动刷新Token")
                        return refreshUserToken()
                    }
                }
                let error = err as NSError
                if (error.code == NSURLErrorDNSLookupFailed || error.code == NSURLErrorCannotFindHost) && E.BaseAPIURL == APIDomain {
                    return adaptiveAPIDNS()
                }
                return Observable.error(err)
            }
        }
        if cache, let request = try? router.asURLRequest(), let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            let cachedJSON = JSON(data: cachedResponse.data, options: .mutableContainers, error: nil)
            APILogger.info(request)
            return observableRequest.startWith(cachedJSON)
        }
        return observableRequest
    }

    private static func adaptiveAPIDNS() -> Observable<()> {
        return APIService<DNSRouter>.get(.apiDNS)
            .map{
                if let url = $0.stringValue.components(separatedBy: ";").first {
                    E.BaseAPIURL = "http://" + url
                }
            }
    }
    
    private static func refreshUserToken() -> Observable<()> {
        return APIService<APIManager>.get(.refreshToken(token: ServiceCenter.auth.currentUserToken))
            .map(ServiceCenter.auth.updateUserAccessToken)
    }

    private static func adaptiveWebDNS() -> Observable<JSON> {
        return APIService<DNSRouter>.get(.webDNS)
            .do(
                onNext: {
                    if let url = $0.stringValue.components(separatedBy: ";").first {
                        E.BaseAPIURL = "http://" + url
                    }
                }
        )
    }
    
}

fileprivate extension DefaultDataResponse {
    
    var result: Alamofire.Result<SwiftyJSON.JSON> {
        if let error = error as NSError? {
            return .failure(error)
        } else if let data = data {
            if let request = request, let response = response {
                URLCache.shared.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
            }
            if let type = response?.mimeType, type == "text/html", let text = String(data: data, encoding: String.Encoding.utf8) {
                return Result.success(JSON(text))
            } else {
                let json = JSON(data: data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
                if json["status"].intValue == 500 {
                    return Result.failure(json["error"].stringValue)
                } else if json["status"].intValue != 0 {
                    return Result.failure(APIError(json))
                } else if json["data"].exists() {
                    return Result.success(json["data"])
                } else {
                    return Result.success(json)
                }
            }
        } else {
            return .failure("获取数据失败，请检查Accept Content Type的设置")
        }
    }
}

enum APIErrorCode: Int {
    case `default` = 0
    case invalidToken = 10011
    case needRefreshToken = 10005
    case refreshTokenFailed = 10010
    case permissionDenied = 10004
    
    var description: String {
        switch self {
        case .invalidToken:
            return "无效Token，需要弹出登录页面"
        case .needRefreshToken:
            return "Token无效，需要刷新Token"
        case .refreshTokenFailed:
            return "刷新token失败，弹出登录页面"
        case .permissionDenied:
            return "用户权限不够"
        case .default:
            return ""
        }
    }
}

struct APIError: ModelType, Error {
    
    let code: APIErrorCode
    let message: String
    
    init(_ json: JSON) {
        code = json["status"].apiErrorCodeValue
        message = json["message"].stringValue
    }
}

fileprivate extension JSON {
    var apiErrorCodeValue: APIErrorCode {
        return APIErrorCode(rawValue: self.intValue) ?? .default
    }
}

extension Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus {
    
    var rawValue: String {
        switch self {
        case .unknown:
            return "未知"
        case .notReachable:
            return "未连接"
        case .reachable(let type):
            switch type {
            case .ethernetOrWiFi:
                return "Wifi"
            default:
                return "移动蜂窝"
            }
        }
    }
}
