//
//  InfiniteScrollingType.swift
//  Pods
//
//  Created by JeffZhao on 2016/10/14.
//
//

import Foundation
import UIKit

// MARK: - 上拉加载更多

public protocol InfiniteScrollingType: class {
    
    /// 添加加载更多
    func addInfiniteScrolling(loadAction: @escaping Action)
    
    /// 停止上拉加载控件的动画，数据加载成功后调用
    func stopInfiniteScrolling()
    
    /// 加载更多请求失败后调用该方法隐藏加载更多的视图
    func dismissInfiniteScrolling()
    
    /// 修改加载更多的可用性
    var infiniteScrollingAvailable: Bool { set get }
    
    /// 上拉加载的视图是否可见
    func infiniteScrollingIsVisiable() -> Bool
    
    /// 加载更多的控件的frame
    var infiniteScrollingViewFrame: CGRect? { get }
    
    /// 是否添加了加载更多的控件
    var infiniteScrollingAdded: Bool { get }    
}

extension UIScrollView: InfiniteScrollingType {
    
}

