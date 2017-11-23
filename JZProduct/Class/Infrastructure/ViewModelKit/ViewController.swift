//
//  ViewController.swift
//  Pods
//
//  Created by JeffZhao on 16/9/23.
//
//

import Foundation
import UIKit
import RxSwift
import MBProgressHUD

open class ViewController: UIViewController, BagOwnerType, ViewModelOwnerType, InfoControllerType, ViewControllerCreatableType {

    public var bag = DisposeBag()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        loadData()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    open var defaultIndicatorType: IndicatorType {
        return .normal
    }
    
    deinit {
        Log.info("[Release]: " + String(describing: self.classForCoder))
    }
    
    @IBAction func onPop() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func onDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        WebImage.clearMemoryCache()
    }
    
//}
//
//extension ViewController {
    
    /// !!!!!!子类重载时如果遵循ViewControllerType协议则必须调用父类实现!!!!!!
    ///
    /// 用于配置UI和其他信息。在调用loadData前自动，仅调用一次
    ///
    open func configUI() {
        guard self is ViewControllerType else { return }
        (self as! ViewControllerType).prepareViewModel()
    }
    
    ///
    /// 默认加载数据流程
    ///
    /// 推荐遵循ForceViewModelType协议，执行默认加载数据流程
    /// 
    /// 不遵循ForceViewModelType协议时，必须重写基类实现，否则会出现数据类型不匹配Error
    ///
    open func loadData() {
        guard self is ViewControllerType else { return }
        (self as! ViewControllerType).defaultLoadData()
    }
    
    /// 请求数据成功后会调用该方法
    ///
    /// 默认实现:
    ///
    ///     调用updateUIEmpty()
    ///
    open func updateUI() {
        hideLoadingIndicator()
        updateUIEmpty()
    }
    
    /// 请求数据失败后会调用该方法
    ///
    /// 默认实现:
    ///
    ///     /// 提示错误信息
    ///     showInfoView(.error(message))
    ///     /// 显示重试的按钮
    ///     updateUIErrorRetry()
    ///
    open func updateUIError(_ message: String) {
        hideLoadingIndicator()
        showInfoView(.error(message))
        updateUIErrorRetry()
    }
    
    /// 请求数据成功后列表没有数据时可能会需要有个提示，比如"您目前没有可接受的订单"
    ///
    /// 可以重写updateUIEmpty
    /// 也可以重写emptyData
    open func updateUIEmpty() {
        guard indirectViewModel()?.isEmpty ?? false else { return }
        let emptyData = self.emptyData
        showSign(imageName: emptyData.imageName,
                 title: emptyData.title,
                 action: { [weak self] in
                    guard let action = emptyData.action else { return }
                    self?.hideSign(imageName: emptyData.imageName)
                    action()
                })
    }
    
    /// 请求数据失败后可能会需要有个提示，比如"点击重试"
    ///
    /// 可以重写updateUIErrorRetry
    /// 也可以重写errorData
    open func updateUIErrorRetry() {
        guard indirectViewModel()?.isEmpty ?? false else { return }
        let errorData = self.errorData
        showSign(imageName: errorData.imageName,
                 title: errorData.title,
                 action: { [weak self] in
                    guard let action = errorData.action else { return }
                    self?.hideSign(imageName: errorData.imageName)
                    action()
                })
    }
    
    /// 添加默认的提示视图到self.view上
    open func showSign(imageName: String, title: String?, action: (() -> ())?) {
        let tag = imageName.hashValue % 100
        guard view.viewWithTag(tag) == nil else {
            return
        }
        let signView = EmptySignView.create()
        signView.with(bundle: Bundle(for: type(of: self)), imageName: imageName, title: title, action: action)
        signView.tag = tag
        self.view.addSubview(signView)
        NSLayoutConstraint(item: signView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: signView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    /// 移除默认的提示视图到self.view上
    open func hideSign(imageName: String) {
        let tag = imageName.hashValue % 100
        if let signView = view.viewWithTag(tag) {
            signView.removeFromSuperview()
        }
    }
    
    /// 请求数据成功后,空数据的提示信息
    ///
    /// 默认返回值:
    ///
    ///     (fileNamePrefix + "_empty", nil, nil)
    ///
    open var emptyData: (imageName: String, title: String?, action: (() -> ())?) {
        let imageName = fileNamePrefix + "_empty"
        return (imageName, nil, nil)
    }
    
    /// 请求数据失败后,空数据的提示信息
    ///
    /// 默认返回值:
    ///
    ///     (fileNamePrefix + "_error", nil, { [weak self] in self?.loadData() })
    ///
    open var errorData: (imageName: String, title: String?, action: (() -> ())?) {
        let imageName = fileNamePrefix + "_error"
        return (imageName, "数据请求失败，点击重试", { [weak self] in self?.loadData() })
    }
    
    /// 默认实现的文件命名前缀
    ///
    /// 比如：
    ///
    ///     ProductDetailViewController -> product_detail
    ///
    public var fileNamePrefix: String {
        return String(describing: self.classForCoder).jz.remove("ViewController").underscore()
    }
//}

//extension ViewController: InfoControllerType {

    public func showLoadingIndicator(type: IndicatorType) {
        switch type {
        case .none:
            break
        case .normal:
            MBProgressHUD.showAdded(to: self.view, animated: true).isUserInteractionEnabled = false
        default:
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
    }
    
    public func hideLoadingIndicator(type: IndicatorType = .normal) {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    open class var storyboardIdentifier: String {
        return "Auth"
    }
}

extension ViewController {
    
    open override var prefersStatusBarHidden: Bool {
        return false
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}

extension UIViewController {
    
    open func performSegue(withSegueID segueID: SegueID, sender: Any?) {
        self.performSegue(withIdentifier: segueID.rawValue, sender: sender)
    }
}
