//
//  AnimationViewType.swift
//  Pods
//
//  Created by JeffZhao on 2016/11/16.
//
//

import Foundation
import UIKit

/// 下拉刷新和加载更多动画视图类型协议
/// 遵循该协议可自定义下拉刷新个加载更多的动画
///
public protocol AnimationViewType: class {
    /// 执行动画
    func play()
    /// 暂停动画
    func pause()
    /// 设置动画的进度
    func setAnimationProgress(progress: CGFloat)
    
    /// 与UIView兼容
    static var asViewType: UIView.Type { get }
    var asView: UIView { get }
}

extension AnimationViewType where Self: UIView {
    
    public var asView: UIView {
        return self
    }
    
    public static var asViewType: UIView.Type {
        return self
    }
}

public typealias Action = () -> ()

