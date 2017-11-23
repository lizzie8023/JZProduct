//
//  ViewControllerType.swift
//  Pods
//
//  Created by JeffZhao on 16/9/23.
//
//

import UIKit
import Foundation
import RxSwift

public protocol ViewControllerType: class {
    
    /// invoked before invoke loadData()
    func configUI()
    /// auto implement by extension
    func loadData()
    
    /// 初始化Model
    func defaultLoadData()
    /// 默认loadData方式
    func prepareViewModel()

    /// invoked after loadData() did success
    func updateUI()
    /// invoked false loadData() failure
    func updateUIError(_ message: String)
    
    /// 加载指示器显示的类型
    var defaultIndicatorType: IndicatorType { get }
}

public extension ViewControllerType where Self: InfoControllerType & BagOwnerType & ViewModelGenerationType {
    
    func prepareViewModel() {
        let _ = self.viewModel
    }
    
    func defaultLoadData() {
        self.viewModel
            /// 请求数据
            .loading()
            /// 加载指示器
            .loadingIndicator(controller: self, indicatorType: defaultIndicatorType)
            /// 更新ViewModel
            .updateViewModel(self)
            /// 请求结束或失败时刷新UI
            .updatingUI(self)
            /// 订阅
            .subscribe()
            /// 控制生命周期
            .disposed(by: bag)
    }
}

public protocol ViewControllerCreatableType: class {
    static func create<E>() -> E
    static var storyboardIdentifier: String { get }
    static var viewControllerIdentifier: String { get }
}

extension ViewControllerCreatableType {
    
    public static func create<E>() -> E {
        return UIStoryboard(name: storyboardIdentifier, bundle: Bundle.main).instantiateViewController(withIdentifier: viewControllerIdentifier) as! E
    }
    
    public static var storyboardIdentifier: String {
        return "Auth"
    }
    
    public static var viewControllerIdentifier: String {
        return String(describing: self)
    }

}
