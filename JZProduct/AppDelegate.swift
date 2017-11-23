//
//  AppDelegate.swift
//  JZProduct
//
//  Created by JeffZhao on 7/10/17.
//  Copyright © 2017 JZ Studio. All rights reserved.
//

import UIKit
import Bugly

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupSDKS()
        setupUI()
        ServiceCenter.auth.regist()
        setupRootViewController()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    
    func setupUI() {
        if !iOSVersion.iOS11 {
            if let cla = NSClassFromString("UINavigationItemButtonView") as? UIAppearanceContainer.Type {
                UIImageView.appearanceWhenContained(within: cla).contentMode = .left
            }
            /// 此处设置的图片并不起决定作用 重点在 Hook.mm 30
            let inset = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: -10)
            UIBarButtonItem.appearance().setBackButtonBackgroundImage(UIImage(named: "navbar_back_white_n")?.withAlignmentRectInsets(inset), for: .normal, barMetrics: .default)
            UIBarButtonItem.appearance().setBackButtonBackgroundImage(UIImage(named: "navbar_back_white_n_h")?.withAlignmentRectInsets(inset), for: [.normal, .highlighted], barMetrics: .default)
        }
    }
    
    func setupRootViewController() {
        guard let _ = window?.rootViewController as? UINavigationController else { return }
        //rootNavigationController.setViewControllers([SignInViewController.create()], animated: false)
    }
    
    func setupSDKS() {
        //WXApi.registerApp(WechatAppID)
        //Bugly.start(withAppId: "02a4c9e355")
    }
}
