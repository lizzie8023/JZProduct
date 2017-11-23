//
//  ColorGradient.swift
//  jianbian
//
//  Created by JeffZhao on 2017/3/9.
//  Copyright © 2017年 JeffZhao. All rights reserved.
//

import Foundation
import UIKit

///
/// 提供颜色渐变相关的视图
/// 渐变方向为从左下角开始到右上角
/// 渐变颜色普通状态为0x56CBD8到0x7AD199 高亮状态为0x4DB6C1到0x6DBB8B
///

//MARK: - 颜色渐变视图的协议
protocol ColorGradientViewType: class {
    /// 配置颜色渐变的Layer 默认实现
    func configColorGradient()
    /// 颜色渐变的Layer的状态 与UIControl的state一致 默认实现
    var colorGradientState: UIControlState { get }
    /// 颜色渐变的Layer 默认实现
    var colorGradientLayer: ColorGradientLayer? { get }
}

extension ColorGradientViewType where Self: UIView {
    
    func configColorGradient() {
        
        if let layer = colorGradientLayer {
            var state = UIControlState.normal
            var colors = [UIColor(hex: 0x56CBD8),
                          UIColor(hex: 0x7AD199)]
            layer.set(colors: colors, state: state)
            layer.set(maskMode: .content(corner: .allCorners, cornerRadii: CGSize.zero), state: state)
            
            state = [.normal, .highlighted]
            colors = [UIColor(hex: 0x4DB6C1),
                      UIColor(hex: 0x6DBB8B)]
            layer.set(colors: colors, state: state)
            layer.set(maskMode: .content(corner: .allCorners, cornerRadii: CGSize.zero), state: state)
            
            layer.updateUI(.normal)
        }
    }
    
    var colorGradientState: UIControlState {
        return .normal
    }
    
    var colorGradientLayer: ColorGradientLayer? {
        return self.layer as? ColorGradientLayer
    }
    
    /// 刷新渐变颜色
    func updateColorGradient() {
        if let layer = colorGradientLayer {
            layer.updateUI(colorGradientState)
        }
    }
    
    /// 设置渐变颜色显示的模式
    func set(maskMode: ColorGradientLayer.MaskMode, state: UIControlState) {
        colorGradientLayer?.set(maskMode: maskMode, state: state)
        updateColorGradient() <- (state == self.colorGradientState)
    }
    
    /// 设置渐变颜色
    func set(colors: [UIColor], state: UIControlState) {
        colorGradientLayer?.set(colors: colors, state: state)
        updateColorGradient() <- (state == self.colorGradientState)
    }
}

// MARK: - 背景颜色渐变的View
/// 通过直接设置 layerClass实现
public class ColorGradientView: UIView, ColorGradientViewType {

    override public class var layerClass: Swift.AnyClass {
        return ColorGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configColorGradient()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configColorGradient()
    }
}

// MARK: - 背景颜色渐变的ImageView
/// 通过直接设置 layerClass实现
class ColorGradientImageView: UIImageView, ColorGradientViewType {
    
    override class var layerClass: Swift.AnyClass {
        return ColorGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configColorGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configColorGradient()
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateColorGradient()
        }
    }
    
    var colorGradientState: UIControlState {
        return isHighlighted ? [.normal, .highlighted] : .normal
    }
}

// MARK: - 背景颜色渐变的Button
/// 通过添加ColorGradientLayer作为子Layer实现
///
/// 提供两种填充样式 线框 和 内部 参考 ColorGradientLayer.MaskMode
///
/// 使用方法：
///     
///     /// 设置内部填充
///     button.set(maskMode: .content(corner: [.bottomLeft,.topLeft], cornerRadii: .fittingMaskCornerRadii), state: .normal)
///     button.set(maskMode: .content(corner: [.bottomLeft,.topLeft], cornerRadii: .fittingMaskCornerRadii), state: [.normal, .highlighted])
///     /// 设置线条边框
///     button.set(maskMode: .line(corner: .allCorners, cornerRadii: .fittingMaskCornerRadii, lineWidth: 2), state: .normal)
///     button.set(maskMode: .line(corner: [.bottomLeft,.topLeft], cornerRadii: .fittingMaskCornerRadii, lineWidth: 2), state: [.normal, .highlighted])
///
class ColorGradientButton: UIButton, ColorGradientViewType {
    
    class ColorGradientButtonLayer: CALayer {
        
        let colorGradientLayer: ColorGradientLayer = ColorGradientLayer()
        
        override var bounds: CGRect {
            didSet {
                colorGradientLayer.frame = bounds
            }
        }
    }
    
    override class var layerClass: Swift.AnyClass {
        return ColorGradientButtonLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configColorGradient()
        configTitleColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configColorGradient()
        configTitleColor()
    }
    
    func configColorGradient() {
        
        backgroundColor = .clear
        
        guard let colorGradientLayer = colorGradientLayer else { return }
        var state = UIControlState.normal
        var colors = [UIColor(hex: 0x56CBD8),
                      UIColor(hex: 0x7AD199)]
        set(colors: colors, state: state)
        set(maskMode: .content(corner: .allCorners, cornerRadii: CGSize.fittingMaskCornerRadii), state: state)
        
        state = [.normal, .highlighted]
        colors = [UIColor(hex: 0x4DB6C1),
                  UIColor(hex: 0x6DBB8B)]
        set(colors: colors, state: state)
        set(maskMode: .content(corner: .allCorners, cornerRadii: CGSize.fittingMaskCornerRadii), state: state)
        
        state = .selected
        colors = [UIColor(hex: 0x56CBD8),
                  UIColor(hex: 0x7AD199)]
        set(colors: colors, state: state)
        set(maskMode: .content(corner: .allCorners, cornerRadii: .fittingMaskCornerRadii), state: state)
        
        
        state = [.selected, .highlighted]
        colors = [UIColor(hex: 0x4DB6C1),
                  UIColor(hex: 0x6DBB8B)]
        set(colors: colors, state: state)
        set(maskMode: .content(corner: .allCorners, cornerRadii: .fittingMaskCornerRadii), state: state)
        
        state = [.disabled]
        colors = [UIColor(hex: 0x4DB6C1),
                  UIColor(hex: 0x6DBB8B)]
        set(colors: colors, state: state)
        set(maskMode: .content(corner: .allCorners, cornerRadii: .fittingMaskCornerRadii), state: state)
        
        layer.addSublayer(colorGradientLayer)
    }
    
    func configTitleColor() {
        /// normal highlighted
        var color = UIColor.white
        setTitleColor(color, for: [.normal])
        setTitleColor(color.withAlphaComponent(0.6), for: [.normal,.highlighted])
        /// selected highlighted
        color = UIColor(hex: 0x43BDCE)
        setTitleColor(color, for: [.selected])
        setTitleColor(color.withAlphaComponent(0.6), for: [.selected,.highlighted])
    }
    
    override var isSelected: Bool {
        didSet {
            updateColorGradient()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateColorGradient()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            updateColorGradient()
        }
    }
    
    var colorGradientLayer: ColorGradientLayer? {
        return (layer as? ColorGradientButtonLayer)?.colorGradientLayer
    }
    
    var colorGradientState: UIControlState {
        return state
    }
    
}

// MARK: - 颜色渐变的layer
class ColorGradientLayer: CAGradientLayer {
    
    enum MaskMode {
        case line(corner: UIRectCorner, cornerRadii: CGSize, lineWidth: CGFloat)
        case content(corner: UIRectCorner,cornerRadii: CGSize)
    }
    
    /// UIControlState mask
    fileprivate var maskModeMap = [UInt: MaskMode]()
    /// UIControlState color
    fileprivate var colorMap = [UInt: [UIColor]]()

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
            updateUI(state)
        }
    }
    
    func set(maskMode: MaskMode, state: UIControlState) {
        maskModeMap[state.rawValue] = maskMode
    }
    
    func set(colors: [UIColor], state: UIControlState) {
        colorMap[state.rawValue] = colors
    }
    
    private var state = UIControlState.normal
    
    func updateUI(_ aState: UIControlState) {
        state = aState
        colors = (colorMap[state.rawValue])?.map{ $0.cgColor }
        mask = maskLayer(bounds: bounds, mode: maskModeMap[state.rawValue])
    }
    
    func setup() {
        startPoint = CGPoint(x: 0, y: 1)
        endPoint = CGPoint(x: 1, y: 0)
        locations = [NSNumber(floatLiteral: 0),
                     NSNumber(floatLiteral: 1)]
    }
}

extension ColorGradientLayer {
    
    /// 根据MaskMode创建相应的MaskLayer
    fileprivate func maskLayer(bounds: CGRect, mode: MaskMode?) -> CAShapeLayer? {
        guard let mode = mode else { return nil }
        let layer = CAShapeLayer()
        let path: UIBezierPath
        switch mode {
        case let .content(corner, cornerRadii):
            path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: cornerRadii == .fittingMaskCornerRadii ? CGSize(width: bounds.midY, height: bounds.midY) : cornerRadii)
        case let .line(corner, cornerRadii, lineWidth):
            layer.strokeColor = UIColor.red.cgColor
            layer.lineWidth = lineWidth
            layer.fillColor = UIColor.clear.cgColor
            path = UIBezierPath(roundedRect: bounds.insetBy(dx: lineWidth, dy: lineWidth), byRoundingCorners: corner, cornerRadii: cornerRadii == .fittingMaskCornerRadii ? CGSize(width: bounds.midY, height: bounds.midY) : cornerRadii)
        }
        layer.path = path.cgPath
        return layer
    }
}

extension CGSize {
    
    /// 自适应cornerRadio
    static var fittingMaskCornerRadii = CGSize(width: -1, height: -1)
    
}
