//
//  RefreshAnimationContainerView.swift
//  Pods
//
//  Created by JeffZhao on 2016/11/16.
//
//

import Foundation
import UIKit

enum PullToRefreshState: Int {
    case normal = 0
    case loading
}

class PullToRefreshView: UIView {
    
    weak var scrollView: UIScrollView?
    let animationView: AnimationViewType
    let action: Action
    let panGestureRecognizer: UIPanGestureRecognizer
    
    var state = PullToRefreshState.normal
    var isObserving = false
    
    var origionTopInset: CGFloat = 0
    
    var height: CGFloat = 60
    
    var trigger = false
    var reverting = false
    
    required init(scrollView aScrollView: UIScrollView, animationViewType: AnimationViewType.Type = DefaultRefreshAnimationView.self, action aAction: @escaping Action) {
        scrollView = aScrollView
        panGestureRecognizer = aScrollView.panGestureRecognizer
        action = aAction
        animationView = animationViewType.asViewType.init(frame: .zero) as! AnimationViewType
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        guard let scrollView = scrollView else { return }
        state = .normal
        origionTopInset = scrollView.contentInset.top
        frame = CGRect(x: 0, y: -height - origionTopInset, width: scrollView.bounds.width, height: height)
        scrollView.addSubview(self)
        addSubview(animationView.asView)
        pullToRefreshAvailable()
    }
}

// MARK: Public

extension PullToRefreshView {
    
    /// 下拉刷新结束时调用该方法来调整下拉刷新视图的状态
    func pullToRefreshDidFinished() {
        resetState(.normal)
    }
    
    /// 下拉刷新是否可见
    func pullToRefreshAvailable(_ available: Bool = true) {
        if available {
            addObserver()
            isHidden = false
        } else {
            removeObserver()
            isHidden = true
        }
    }
    
    /// 主动触发下拉刷新
    func triggerPullToRefresh() {
        trigger = true
        scrollView?.setContentOffset(CGPoint(x: 0, y: -frame.height), animated: true)
    }
}

// MARK: Clear while remove from scrollView

extension PullToRefreshView {
    
    override func removeFromSuperview() {
        removeObserver()
        super.removeFromSuperview()
    }
}

// MARK: Change contentInset

extension PullToRefreshView {
    
    func resetScrollViewContentInset() {
        guard let scrollView = scrollView else { return }
        let y = scrollView.contentOffset.y
        var currentInsets = scrollView.contentInset
        if y < 0 {
            currentInsets.top = abs(y)
            scrollView.contentInset = currentInsets
        }
        currentInsets.top = origionTopInset
        setScrollViewContentInset(currentInsets, completionHandle: { [weak self] in
            self?.animationView.setAnimationProgress(progress: 0)
            self?.reverting = false
        })
    }
    
    func setScrollViewContentInsetForRefreshView() {
        guard let scrollView = scrollView else { return }
        var currentInsets = scrollView.contentInset
        currentInsets.top = origionTopInset + height
        setScrollViewContentInset(currentInsets)
    }
    
    func setScrollViewContentInset(_ contentInset: UIEdgeInsets, completionHandle: Action? = nil) {
        guard let scrollView = scrollView else { return }
        panGestureRecognizer.isEnabled = false
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
                scrollView.contentInset = contentInset
            },
            completion: { _ in
                completionHandle?()
                self.panGestureRecognizer.isEnabled = true
            })
    }
}

// MARK: KVO
extension PullToRefreshView {
    
    func addObserver() {
        guard !isObserving else { return }
        guard let scrollView = scrollView else { return }
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        scrollView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        scrollView.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
        panGestureRecognizer.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.new, context: nil)
        isObserving = true
    }
    
    func removeObserver() {
        guard isObserving else { return }
        guard let scrollView = superview as? UIScrollView else { return }
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
        scrollView.removeObserver(self, forKeyPath: "contentSize")
        scrollView.removeObserver(self, forKeyPath: "bounds")
        panGestureRecognizer.removeObserver(self, forKeyPath: "state")
        isObserving = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = scrollView else { return }
        if keyPath == "contentOffset", let offset = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgPointValue {
            scrollViewDidScroll(offset)
        } else if keyPath == "contentSize", let contentSize = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgSizeValue {
            resetFrame(contentSize: contentSize, bounds: scrollView.bounds)
        } else if keyPath == "bounds", let bounds = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue  {
            resetFrame(contentSize: scrollView.contentSize, bounds: bounds)
        } else if keyPath == "state",
            let state = (change?[NSKeyValueChangeKey.newKey] as? NSNumber)?.int32Value , UIGestureRecognizerState.ended.rawValue == Int(state) {
            if scrollView.contentOffset.y <= (-height - origionTopInset) {
                resetState(.loading)
            }
        }
    }
}

// MARK: Scroll

extension PullToRefreshView {
    
    func scrollViewDidScroll(_ contentOffset: CGPoint) {
        guard !reverting else { return }
        guard state != .loading else { return }
        if contentOffset.y < -origionTopInset {
            let v = abs(contentOffset.y) - origionTopInset
            let progress = min(1, v / height)
            animationView.setAnimationProgress(progress: progress)
            if trigger && progress == 1.0 {
                trigger = false
                resetState(.loading)
            }
        } else {
            animationView.setAnimationProgress(progress: 0)
        }
    }
    
    func resetFrame(contentSize: CGSize, bounds scrollViewBounds: CGRect) {
        frame = CGRect(x: 0, y: -height - origionTopInset, width: scrollViewBounds.size.width, height: height)
        animationView.asView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}

// MARK: State

private extension PullToRefreshView{
    
    func resetState(_ aState: PullToRefreshState) {
        guard state != aState else {
            return
        }
        state = aState
        switch aState {
        case .normal:
            reverting = true
            animationView.pause()
            resetScrollViewContentInset()
        case .loading:
            setScrollViewContentInsetForRefreshView()
            animationView.play()
            action()
        }
    }
}

