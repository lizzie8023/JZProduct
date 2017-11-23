//
//  InfiniteScrollingAnimationContainerView.swift
//  Pods
//
//  Created by JeffZhao on 2016/11/16.
//
//

import Foundation
import UIKit

enum AnimationPaginationState : Int {
    case stopped = 0
    case triggered
    case loading
}

/// 动图size 72x72
let animationPaginatorHeight: CGFloat = 60

/// 上拉加载的显示视图
class AnimationPaginator: UIView {
    
    let paginatorAnimationView = LoadMoreAnimationView(activityIndicatorStyle: .gray)
    
    weak var scrollView: UIScrollView?
    var panGestureRecognizer: UIPanGestureRecognizer?
    
    var action: Action?
    var originalBottomInset: CGFloat = 0
    
    let staticProgress: CGFloat = 1.0 //24 / 52.0
    
    var state = AnimationPaginationState.stopped
    
    func resetState(_ newValue: AnimationPaginationState) {
        guard state != newValue else { return }
        state = newValue
        switch newValue {
        case .loading:
            paginatorAnimationView.play()
            action?()
        case .stopped:
            paginatorAnimationView.setAnimationProgress(progress: 0)
        case .triggered:
            break;
        }
    }
}

/// 约束
extension AnimationPaginator {
    
    func set(scrollView aScrollView: UIScrollView, action aAction: Action?) {
        let rect = CGRect(x: 0, y: max(aScrollView.contentSize.height, aScrollView.bounds.height), width: aScrollView.bounds.width, height: animationPaginatorHeight)
        frame = rect
        action = aAction
        setupLayoutConstraint()
        scrollView = aScrollView
        panGestureRecognizer = aScrollView.panGestureRecognizer
        originalBottomInset = aScrollView.contentInset.bottom
        addObservers()
        correctScrollViewContentInsetForPaginator(animated: false)
    }
    
    func setupLayoutConstraint() {
        
        paginatorAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(paginatorAnimationView)
        [
            NSLayoutConstraint(
                item: paginatorAnimationView,
                attribute: NSLayoutAttribute.centerX,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.centerX,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: paginatorAnimationView,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: paginatorAnimationView,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.width,
                multiplier: 1.0,
                constant: 72
            ),
            NSLayoutConstraint(
                item: paginatorAnimationView,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.height,
                multiplier: 1.0,
                constant: 72
            )
            ].forEach{ $0.isActive = true }
    }
}

/// scrollView insets
extension AnimationPaginator {
    
    /// scrollView移除AnimationPaginator后重置insets和offset
    func revertScrollViewContentInset() {
        guard let scrollView = scrollView else { return }
        let delta = scrollView.contentOffset.y + scrollView.bounds.height - scrollView.contentSize.height;
        var currentInsets = scrollView.contentInset
        currentInsets.bottom = originalBottomInset
        scrollView.contentInset = currentInsets
        if delta > 0 && scrollView.contentSize.height > scrollView.bounds.height {
            var offset = scrollView.contentOffset
            offset.y += delta
            scrollView.contentOffset = offset
            panGestureRecognizer?.setTranslation(CGPoint(x: 0, y: -delta + bounds.height), in: scrollView)
        }
    }
    
    /// scrollView添加AnimationPaginator后设置insets
    func correctScrollViewContentInsetForPaginator(animated: Bool = true) {
        guard let scrollView = scrollView else { return }
        var currentInsets = scrollView.contentInset
        currentInsets.bottom = originalBottomInset + bounds.height;
        if animated {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.allowUserInteraction, .beginFromCurrentState],
                animations: { self.scrollView?.contentInset = currentInsets },
                completion: nil
            )
        } else {
            scrollView.contentInset = currentInsets
        }
    }
}

/// KVO
extension AnimationPaginator {
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if let _ = superview as? UIScrollView , newSuperview == nil {
            removeObservers()
            panGestureRecognizer = nil
        }
    }
    
    func addObservers() {
        if let scrollView = scrollView {
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
            scrollView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
            scrollView.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
        }
        if let panGestureRecognizer = panGestureRecognizer {
            panGestureRecognizer.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    
    func removeObservers() {
        if let panGestureRecognizer = panGestureRecognizer  {
            panGestureRecognizer.removeObserver(self, forKeyPath: "state", context: nil)
        }
        if let scrollView = self.superview as? UIScrollView {
            scrollView.removeObserver(self, forKeyPath: "contentOffset", context: nil)
            scrollView.removeObserver(self, forKeyPath: "contentSize", context: nil)
            scrollView.removeObserver(self, forKeyPath: "bounds", context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = scrollView else { return }
        if keyPath == "contentOffset",
            let offset = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgPointValue {
            scrollViewDidScroll(contentOffset: offset)
        } else if keyPath == "contentSize",
            let contentSize = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgSizeValue {
            frame = CGRect(x: 0, y: max(contentSize.height, scrollView.bounds.height), width: scrollView.bounds.width, height: animationPaginatorHeight)
        } else if keyPath == "bounds",
            let bounds = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue  {
            frame = CGRect(x: 0, y: max(scrollView.contentSize.height, scrollView.bounds.height), width: bounds.size.width, height: animationPaginatorHeight)
        } else if keyPath == "state",
            let state = (change?[NSKeyValueChangeKey.newKey] as? NSNumber)?.intValue, UIGestureRecognizerState.ended.rawValue == Int(state) {
            if self.state == .triggered {
                resetState(.loading)
            }
        }
    }
    
    fileprivate func scrollViewDidScroll(contentOffset: CGPoint) {
        guard !isHidden else { return }
        guard state != .loading else { return }
        guard let scrollView = scrollView else { return }
        let contentHeight = scrollView.contentSize.height
        let expMaxOffset = max(0, contentHeight - scrollView.bounds.height)
        if contentOffset.y - expMaxOffset > 0 {
            let progress = min(1, max(0, (contentOffset.y - expMaxOffset) / animationPaginatorHeight))
            paginatorAnimationView.setAnimationProgress(progress: staticProgress * progress)
            if progress == 1.0 && !scrollView.isTracking && !scrollView.isDragging {
                resetState(.loading)
            } else if scrollView.isDragging {
                resetState(.triggered)
            } else if state == .triggered {
                resetState(.loading)
            }
        }
    }
}

