//
//  AuthService.swift
//  UFace
//
//  Created by JeffZhao on 1/18/17.
//  Copyright © 2017 JeffZhao. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

extension ServiceCenter {
    static var auth: AuthService {
        return ServiceCenter.default.service(AuthService.self)
    }
}

class AuthService: NSObject, ServiceType {
    
    fileprivate(set) var user: User?
    
    fileprivate let logintObservable = PublishSubject<Void>()
    
    fileprivate let logoutObservable = PublishSubject<Void>()
    
    fileprivate var wechatLoginObserver: AnyObserver<JSON>?
    
    var wechatLoginInfoBag = DisposeBag()
    
    var needShowLoginViewBag = DisposeBag()
    
    override required init() {
        super.init()
    }
    
    /// 只在App启动时执行一次
    func regist() {
        loadUser()
        configForceShowLoginView()
    }
    
    /// 处理URL
    func handle(url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
}

// MARK - 登录状态
extension AuthService {
    
    /// 上一次用户登录的用户名
    var lastLoginUserName: String? {
        get {
            return UserDefaults.standard.string(forKey: "LastLoginUserName")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LastLoginUserName")
        }
    }
    
    var isLogined: Bool {
        return user != nil
    }
    
    var userDidLoginObservable: Observable<Void> {
        return logintObservable.asObserver()
    }
    
    var userDidLogoutObservable: Observable<Void> {
        return logoutObservable.asObserver()
    }
    
    var currentUserToken: String {
        return user?.token ?? ""
    }
}

extension AuthService {
    
    /// 只在App启动时执行一次
    fileprivate func loadUser() {
        if let data = UserDefaults.standard.value(forKey: "UserData") as? Data {
            let json = JSON(data: data)
            if json.type == .null {
                Log.info("用户未登录")
            } else {
                user = User(json)
                Log.info("用户已登录, id: \(self.user!.id) token: \(self.user!.token)")
                VarCenter.default.refreshVarFromService()
            }
        } else {
            Log.info("用户未登录")
        }
    }
    
    fileprivate func configForceShowLoginView() {
        UserDidLogOutObservable
            .subscribe(onNext: { [weak self] _ in
                self?.logoutUser()
                ViewManager.showLoginView()
            })
            .disposed(by: needShowLoginViewBag)
    }
    
    /// 只在用户退出登录时执行
    func logoutUser() {
        UserDefaults.standard.set(nil, forKey: "UserData")
        user = nil
    }
    
    /// 只在用户登录成功后调用一次
    func saveUserAfterLogin(_ user: User) {
        self.user = user
        saveUser(user: user)
        VarCenter.default.refreshVarFromService()
        Log.info("用户登录, id: \(user.id), token: \(user.token)")
    }
}

extension AuthService {
    
    func login(username: String?, password: String?) -> Observable<User> {
        lastLoginUserName = username
        return APIService<APIManager>.post(.userLogin(userName: username ?? "", password: password ?? ""))
            .map(User.init)
            .do(onNext: saveUserAfterLogin)
    }
    
    func wechatLogin() -> Observable<User> {
        let observable: Observable<JSON> = Observable.create({ observer in
            self.wechatLoginObserver = observer
            let req = SendAuthReq()
            req.scope = "snsapi_userinfo"
            req.state = "12345"
            WXApi.send(req)
            return Disposables.create()
        })
        return observable
            .map(User.init)
            .do(onNext: saveUserAfterLogin)
    }
}

extension AuthService {

    /// 会调用多次 比如用户登录成功时 刷新Token后 用户更新信息后
    func saveUser(user: User) {
        if let data = try? user.jsonValue.rawData() {
            UserDefaults.standard.set(data, forKey: "UserData")
            UserDefaults.standard.synchronize()
            Log.info("存储用户信息成功")
        } else {
            Log.info("存储用户信息失败")
        }
    }
}


extension AuthService: WXApiDelegate {
    
    func onReq(_ req: BaseReq!) {
        
    }
    
    func onResp(_ resp: BaseResp!) {
        if let resp = resp as? SendAuthResp {
            if resp.errCode == 0, let code = resp.code {
                let url = "https://api.weixin.qq.com/sns/oauth2/access_token"
                let params = ["appid":WechatAppID, "secret": WechatAppSecret, "code": code, "grant_type": "authorization_code"]
                Alamofire.request(url, method: HTTPMethod.get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { json in
                    switch json.result {
                    case let .success(value):
                        let result = JSON(value)
                        if result["errcode"].exists() {
                            self.wechatLoginObserver?.onError(result["errmsg"].stringValue)
                        } else {
                            self.handleWechatAuthInfo(AuthService.WechatAuthInfo(result))
                        }
                    case let .failure(errorMsg):
                        self.wechatLoginObserver?.onError(errorMsg)
                    }
                })
            } else if let errStr = resp.errStr {
                wechatLoginObserver?.onError(errStr)
            }
        }
    }
    
    struct WechatAuthInfo: ModelType {
        
        let access_token: String
        let expires_in: Int
        let openid: String
        let refresh_token: String
        let unionid: String
        let scope: String
        
        init(_ json: JSON) {
            access_token = json["access_token"].stringValue
            expires_in = json["expires_in"].intValue
            openid = json["openid"].stringValue
            refresh_token = json["refresh_token"].stringValue
            unionid = json["unionid"].stringValue
            scope = json["scope"].stringValue
        }
    }
    
    func handleWechatAuthInfo(_ info: WechatAuthInfo) {
        guard let observer = self.wechatLoginObserver else { return }
        wechatLoginInfoBag = DisposeBag()
        _ = observer
        /// 后续处理微信登录
//        APIService<APIManager>.post(.wechatSignIn(access_token: info.access_token, openid: info.openid, refresh_token: info.refresh_token, expires_in: info.expires_in))
//            .do(
//                onError: { _ in
//                    self.wechatLoginObserver = nil
//                },
//                onCompleted: {
//                    self.wechatLoginObserver = nil
//                })
//            .subscribe(observer.on).addDisposableTo(bag)
    }
}

extension AuthService {
    
    /// Update
    func updateUserAccessToken(_ json: JSON) {
        user?.token = json["token"].stringValue
        Log.info("---> updateUserAccessToken:\(json["token"].stringValue)")
        save()
    }
    
    func update(avatar: String) {
        user?.avatar_url = avatar
        save()
    }
    
    func update(gender: Int) {
        save()
    }
    
    func update(userName: String) {
//        user?.username = userName
        save()
    }
    
    private func save() {
        guard let user = user else { return }
        saveUser(user: user)
    }
}
