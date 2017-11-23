//
//  UIScrollView+PullToRefresh.swift
//  PullToRefresh
//
//  Created by JeffZhao on 16/7/27.
//  Copyright © 2016年 JeffZhao. All rights reserved.
//

import Foundation
import UIKit

private var pullToRefreshAnimationViewKey = "PullToRefresh/PullToRefreshAnimationViewKey"

public extension PullToRefreshType where Self: UIScrollView {
    
    fileprivate var pullToRefreshView: PullToRefreshView? {
        get {
            return self.jz.getAssociatedObject(key: &pullToRefreshAnimationViewKey)
        }
        set {
            self.jz.setAssociatedObject(key: &pullToRefreshAnimationViewKey, value: newValue)
        }
    }
    
    /// 添加下拉刷新
    ///
    /// - Parameters:
    ///   - loadAction: 刷新时需要执行的事件
    ///   - animationViewType: 刷新动画的视图类型
    public func addPullToRefresh(animationViewType: AnimationViewType.Type = DefaultRefreshAnimationView.self, loadAction: @escaping Action) {
        pullToRefreshView?.removeFromSuperview()
        pullToRefreshView = PullToRefreshView(scrollView: self, animationViewType: animationViewType, action: loadAction)
    }
    
    /// 下拉刷新结束时调用该方法来调整下拉刷新视图的状态
    func pullToRefreshDidFinished() {
        pullToRefreshView?.pullToRefreshDidFinished()
    }
    
    /// 下拉刷新是否可见
    var pullToRefreshAvailable: Bool {
        get {
            return !(pullToRefreshView?.isHidden ?? true)
        }
        set {
            pullToRefreshView?.pullToRefreshAvailable(newValue)
        }
    }
    
    /// 主动触发下拉刷新
    func triggerPullToRefresh() {
        pullToRefreshView?.triggerPullToRefresh()
    }
    
    /// 是否添加了下拉刷新控件
    var pullToRefreshViewAdded: Bool {
        return pullToRefreshView != nil
    }
}

