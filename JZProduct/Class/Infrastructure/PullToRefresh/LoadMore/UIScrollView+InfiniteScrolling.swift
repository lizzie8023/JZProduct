//
//  UIScrollView+InfiniteScrolling.swift
//  PullToRefresh
//
//  Created by JeffZhao on 16/4/5.
//  Copyright © 2016年 JeffZhao. All rights reserved.
//

import Foundation
import UIKit

private var animationPaginatorKey = "PullToRefresh/AnimationPaginatorKey"

public extension InfiniteScrollingType where Self: UIScrollView {
    
    fileprivate var animationPaginator: AnimationPaginator? {
        get {
            return self.jz.getAssociatedObject(key: &animationPaginatorKey)
        }
        set {
            self.jz.setAssociatedObject(key: &animationPaginatorKey, value: newValue)
        }
    }

    /// 添加上拉加载更多功能
    func addInfiniteScrolling(loadAction: @escaping Action) {
        if let animationPaginator = animationPaginator {
            animationPaginator.action = loadAction
        } else {
            let animationPaginator = AnimationPaginator()
            animationPaginator.set(scrollView: self, action: loadAction)
            addSubview(animationPaginator)
            self.animationPaginator = animationPaginator
        }
    }
    
    /// 停止上拉加载控件的动画，数据加载成功后调用
    func stopInfiniteScrolling() {
        panGestureRecognizer.isEnabled = false
        animationPaginator?.resetState(.stopped)
        panGestureRecognizer.isEnabled = true
    }
    
    /// 加载更多请求失败后调用该方法隐藏加载更多的视图
    func dismissInfiniteScrolling() {
        guard let animationPaginator = animationPaginator, !animationPaginator.isHidden else { return }
        guard animationPaginator.state != .stopped else { return }
        let delta = contentOffset.y + bounds.height - contentSize.height;
        guard delta > 0 else {
            self.animationPaginator?.resetState(.stopped)
            return
        }
        panGestureRecognizer.isEnabled = false
        var offset = contentOffset
        offset.y -= delta
        offset.y = max(offset.y, contentSize.height - bounds.height)
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.setContentOffset(offset, animated: true)
            },
            completion: { _ in
                self.panGestureRecognizer.isEnabled = true
                self.animationPaginator?.resetState(.stopped)
            }
        )
    }
    
    /// 修改加载更多的可用性
    var infiniteScrollingAvailable: Bool {
        get {
            guard let animationPaginator = animationPaginator else { return false }
            return !animationPaginator.isHidden
        }
        set {
            animationPaginator?.isHidden = !newValue
            if newValue {
                animationPaginator?.correctScrollViewContentInsetForPaginator()
            } else {
                animationPaginator?.revertScrollViewContentInset()
            }
        }
    }
    
    /// 上拉加载的视图是否可见
    func infiniteScrollingIsVisiable() -> Bool {
        guard infiniteScrollingAvailable else { return false }
        return contentOffset.y + bounds.height - contentSize.height + animationPaginatorHeight > 0
    }
    
    /// 加载更多的控件的frame
    var infiniteScrollingViewFrame: CGRect? {
        return animationPaginator?.frame
    }
    
    /// 是否添加了加载更多的控件
    var infiniteScrollingAdded: Bool {
        return animationPaginator != nil
    }
}

