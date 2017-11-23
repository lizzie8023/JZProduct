//
//  PullToRefreshType.swift
//  Pods
//
//  Created by JeffZhao on 2016/10/14.
//
//

import Foundation
import UIKit

public protocol PullToRefreshType: class {
    
    /// 添加下拉刷新
    func addPullToRefresh(animationViewType: AnimationViewType.Type, loadAction: @escaping Action)
    
    /// 下拉刷新结束时调用该方法来调整下拉刷新视图的状态
    func pullToRefreshDidFinished()
    
    /// 设置是否显示下拉刷新
    var pullToRefreshAvailable: Bool { get set }
    
    /// 主动触发下拉刷新
    func triggerPullToRefresh()
        
    /// 是否添加了下拉刷新控件
    var pullToRefreshViewAdded: Bool { get }
}

extension UIScrollView: PullToRefreshType {
    
}

