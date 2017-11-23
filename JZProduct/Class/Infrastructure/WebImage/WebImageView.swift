//
//  WebImageView.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/7/28.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import Foundation
import UIKit

class WebImageProgressView: UIProgressView {
    class func create() -> WebImageProgressView? {
        return UINib(nibName: "WebImageProgressView", bundle: Bundle(for: WebImageProgressView.self)).instantiate(withOwner: nil, options: nil).first as? WebImageProgressView
    }
}
/// 背景颜色: [加载中]浅蓝色渐变 [加载失败]深蓝色渐变
/// 顶部有蓝色进度条
class WebImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addProgressView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addProgressView()
    }
    
    /// For ColorGradient
    override class var layerClass: Swift.AnyClass {
        return WebImageLayer.self
    }
    
    /// For Loading
    
    var showProgressView: Bool {
        set {
            self.progressView?.isHidden = newValue
        }
        get {
            return self.progressView?.isHidden ?? false
        }
    }
    
    private let progressView = WebImageProgressView.create()
    
    private func addProgressView() {
        if let progressView = progressView, progressView.superview == nil {
            progressView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(progressView)
            NSLayoutConstraint(item: progressView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: progressView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: progressView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: progressView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 2).isActive = true
        }
    }
    
    func setWebImageState(_ state: WebImageLayer.State) {
        DispatchQueue.main.async {
            (self.layer as? WebImageLayer)?.updateUI(state: state)
            self.progressView?.isHidden = state != .loading
        }
    }
    
    func setProgress(_ progress: Float) {
        DispatchQueue.main.async {
            self.progressView?.progress = progress
        }
    }
}

/// 颜色渐变的Layer
class WebImageLayer: CAGradientLayer {
    
    enum State: Int {
        case normal = 0
        case loading = 1
        case loadFailed = 2
    }
    
    private var colorMap = [State: [UIColor]]()
    
    private var state = State.normal
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    override var bounds: CGRect {
        didSet {
            updateUI(state: state)
        }
    }
    
    private func setup() {
        set(colors: [.white, .white], state: .normal)
//        set(colors: [Palette.viewColor_85A4E8_50, Palette.viewColor_85A4E8_30], state: .loading)
//        set(colors: [Palette.viewColor_85A4E8, Palette.viewColor_85A4E8_60], state: .loadFailed)
        startPoint = CGPoint(x: 0, y: 1)
        endPoint = CGPoint(x: 1, y: 1)
        locations = [NSNumber(floatLiteral: 0),
                     NSNumber(floatLiteral: 1)]
    }
    
    fileprivate func updateUI(state: State) {
        self.state = state
        colors = (colorMap[state])?.map{ $0.cgColor }
    }
    
    private func set(colors: [UIColor], state: State) {
        colorMap[state] = colors
    }
}

