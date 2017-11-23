//
//  ViewManager.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/7/12.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import LGAlertView

struct ViewManager {
    
    
    /// Push without pop back
    static func showLoginView() {
        rootNavigationController?.setViewControllers([SignInViewController.create()], animated: true)
    }
    
    static var rootNavigationController: RootNavigationController? {
        return UIApplication.shared.keyWindow?.rootViewController as? RootNavigationController
    }
    
    static var rootTabbarViewController: RootTabBarController? {
        return rootNavigationController?.viewControllers.first as? RootTabBarController
    }

    /// model
    static var loginObservable: Observable<()> {
        return Observable.create({ observer in
            let signInVC: SignInViewController = SignInViewController.create()
            signInVC.didLoginCallBack = {
                observer.onNext(())
                observer.onCompleted()
            }
            let signInNav = NavigationController(rootViewController: signInVC)
            rootNavigationController?.present(signInNav, animated: true, completion: nil)
            return Disposables.create()
        })
    }
    
    static func showUserLogoutView(barButtonItem: UIBarButtonItem?) {
        let title = ""
        if #available(iOS 11.0, *) {
            _showUserLogoutView(barButtonItem: barButtonItem, title: title)
        } else {
            _showUserLogoutView(button: barButtonItem?.customView as? UIButton, title: title)
        }
    }
    
    private static func _showUserLogoutView(barButtonItem: UIBarButtonItem?, title: String) {
        
        guard let barButtonItem = barButtonItem else {
            Log.error("请指定 UIBarButtonItem")
            return
        }
        guard let vc = UIStoryboard(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogoutPopoverViewController") as? LogoutPopoverViewController else {
            Log.error("请检查LogoutPopoverViewController")
            return
        }
        vc.userTitle = title
        let width = max(title.jz.boundingSize(limitSize: CGSize(width: 1000, height: 1000), font: UIFont.regularFont(ofSize: 15)).width, 133) + 25
        let height: CGFloat = 126
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.preferredContentSize = CGSize(width: width, height: height)
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.backgroundColor = UIColor.white
        popover.sourceView = rootNavigationController?.view
        popover.barButtonItem = barButtonItem
        popover.delegate = vc
        rootNavigationController?.present(vc, animated: true, completion:nil)
    }
    
    private static func _showUserLogoutView(button: UIButton?, title: String) {
        guard let button = button else {
            Log.error("请指定 button")
            return
        }
        guard let vc = UIStoryboard(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogoutPopoverViewController") as? LogoutPopoverViewController else {
            Log.error("请检查LogoutPopoverViewController")
            return
        }
        vc.userTitle = title
        let width = max(title.jz.boundingSize(limitSize: CGSize(width: 1000, height: 1000), font: UIFont.regularFont(ofSize: 15)).width, 133) + 25
        let height: CGFloat = 126
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.preferredContentSize = CGSize(width: width, height: height)
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.backgroundColor = UIColor.white
        popover.sourceView = rootNavigationController?.view
        var rect = button.frame
        if let imageView = button.imageView {
            rect.origin.y += imageView.bounds.midY + 2
            rect.origin.x += rect.width * 0.5 - imageView.bounds.midX
        }
        popover.sourceRect = rect
        popover.delegate = vc
        rootNavigationController?.present(vc, animated: true, completion:nil)
    }
}

import MessageUI
import Photos

extension ViewManager {
    
    static func callPhoneNumber(_ number: String) throws {
        let url: URL = try "tel://\(number)".asURL()
        let alert = UIAlertController(style: .alert, title: "拨打 \(number)?", message: "")
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { action in
            UIApplication.shared.openURL(url)
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func saveImageToPhotoAlbum(image: UIImage, completion:@escaping (Bool) -> ()) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { result, error in
            DispatchQueue.main.async {
                completion(result)
            }
        })
    }
    
    static func showTapPhoneNumberActionSheet(phoneNumber: String, orderID: String, fromVC: ViewController?) {
        let callAction = UIAlertAction(title: "致电", style: .default, handler: { (action) in
            try? ViewManager.callPhoneNumber(phoneNumber)
        })
        let smsAction = UIAlertAction(title: "短信", style: .default, handler: { (action) in
        })
        let copyAction = UIAlertAction(title: "复制", style: .default, handler: { (action) in
            UIPasteboard.general.string = phoneNumber
            fromVC?.showInfoView(.toast("已复制"))
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        WDAlertController.show(.actionSheet, title: phoneNumber, message: nil, actions: [callAction, smsAction, copyAction, cancelAction])
    }

    
}
