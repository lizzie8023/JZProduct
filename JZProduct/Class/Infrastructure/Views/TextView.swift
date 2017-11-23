//
//  TextView.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/9/12.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import Foundation
import UIKit

class TextView: UITextView {
    
    let placeholderLabel = Label()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPlaceHolderLabel()
        addTextObserver()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupPlaceHolderLabel()
        addTextObserver()
    }
    
    private func setupPlaceHolderLabel() {
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.textColor = textColor?.withAlphaComponent(0.6)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.font = font
        placeholderLabel.textInsets = textContainerInset
        addSubview(placeholderLabel)
        NSLayoutConstraint(item: placeholderLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: placeholderLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: placeholderLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: placeholderLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    private func addTextObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(TextView.observedTextChanged(_:)), name: .UITextViewTextDidChange, object: nil)
        addObserver(self, forKeyPath: "text", options: .new, context: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UITextViewTextDidChange, object: nil)
        removeObserver(self, forKeyPath: "text")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text" {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
    @objc private
    func observedTextChanged(_ noti: Notification) {
        if let textView = noti.object as? UITextView, textView == self {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
}

extension TextView {
    
    var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
        }
    }
    
    var placeholderTextInsets: UIEdgeInsets {
        get {
            return placeholderLabel.textInsets
        }
        set {
            placeholderLabel.textInsets = newValue
            placeholderLabel.text = placeholderLabel.text
        }
    }
}
