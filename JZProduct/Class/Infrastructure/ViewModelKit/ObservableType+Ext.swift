//
//  ObservableType+Ext.swift
//  Pods
//
//  Created by JeffZhao on 16/9/23.
//
//

import Foundation
import UIKit
import RxSwift
import SwiftyJSON

public extension ObservableType {
    
    func loadingIndicator(controller vc: InfoControllerType, indicatorType type: IndicatorType = .normal) -> Observable<E> {
        weak var viewController = vc
        return self.do(
            onError: {  _ in
                viewController?.hideLoadingIndicator(type: type)
            },
            onCompleted: {
                viewController?.hideLoadingIndicator(type: type)
            },
            onSubscribe: {
                viewController?.showLoadingIndicator(type: type)
            },
            onDispose: {
                viewController?.hideLoadingIndicator(type: type)
            }
        )
    }
    
    func updatingUI(_ vc: ViewControllerType) -> Observable<E> {
        weak var viewController = vc
        return self.do(
            onNext:  { _ in
                viewController?.updateUI()
            },
            onError: {
                viewController?.updateUIError($0.relativeString)
            }
        )
    }
    
    func updatingUIError(_ vc: ViewControllerType) -> Observable<E> {
        weak var viewController = vc
        return self.do(
            onError: {
                viewController?.updateUIError($0.relativeString)
            }
        )
    }
}

public extension ObservableType where Self.E == ViewModelType {
    
    func updateViewModel(_ vc: ViewModelOwnerType) -> Observable<E> {
        weak var viewController = vc
        return self.do(
            onNext: {
                viewController?.setViewModel($0)
            }
        )
    }
    
}

public extension Error {
    
    /// 返回Error实例格式化后的字符串
    ///
    /// String， 返回自身
    /// JSON， 可以转化为String类型是输出stringValue
    /// NSError，取userInfo中的NSLocalizedDescription字段对应的值
    var relativeString: String {
        if let string = self as? String {
            return string
        } else if let json = self as? JSON, let string = json.string, !string.isEmpty {
            return string
        } else if let error = self as? APIError {
            return error.message
        }
        let error = self as NSError
        return JSON(error.userInfo)["NSLocalizedDescription"].stringValue
    }
    
}
