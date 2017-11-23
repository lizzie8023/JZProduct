//
//  InfoControllerType.swift
//  Pods
//
//  Created by JeffZhao on 16/9/23.
//
//

import Foundation
import UIKit
import Toaster

public enum IndicatorType {
    /// 不显示
    case none
    /// 普通的
    case normal
    /// 阻断View交互
    case blockContainer
    /// 阻断Window交互
    case blockWindow
}

public enum InfoType {
    /// 提示消息
    case toast(String)
    /// Alert消息
    case alert(String, String, [UIAlertAction])
    /// 错误消息
    case error(String)
    case sign(String, String?, (() -> ())?)
}

public protocol InfoControllerType: class {
    
    func showInfoView(_ type: InfoType)
    
    /// 此处不省略形参主要是区分函数签名
    func showLoadingIndicator(type: IndicatorType)
    
    /// 此处不省略形参主要是区分函数签名
    func hideLoadingIndicator(type: IndicatorType)
    
    var emptyData: (imageName: String, title: String?, action: (() -> ())?) { get }
    
    func showSign(imageName: String, title: String?, action: (() -> ())?)
}

public extension InfoControllerType {
    
    func showInfoView(_ type: InfoType) {
        switch type {
        case let .toast(message):
            self.showToast(message)
        case let .alert(title, message, actions):
            self.showAlert(title, message: message, actions: actions)
        case let .error(message):
            self.showError(message)
        case let .sign(imageName, title, action):
            showSign(imageName: imageName, title: title, action: action)
        }
    }
    
    func showToast(_ message: String) {
        guard !message.jz.trimmed().isEmpty else { return }
        Toast(text: message).show()
    }
    
    func showError(_ message: String) {
        guard !message.jz.trimmed().isEmpty else { return }
        showToast(message)
    }
    
    func showAlert(_ title: String?, message: String?, actions: [UIAlertAction]) {
        guard title != nil || message != nil else { return }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

