//
//  XibView.swift
//  UFace
//
//  Created by JeffZhao on 15/11/6.
//  Copyright © 2015年 JZ Studio. All rights reserved.
//

import UIKit

@IBDesignable class XibView: UIView {

    @IBInspectable var index: Int = 0 {
        didSet {
            xibSetUpWithIndex(index)
            xibViewDidLoaded()
        }
    }

    fileprivate func xibSetUpWithIndex(_ index: Int) {
        subviews.forEach{ $0.removeFromSuperview() }
        let view = loadViewFromXib(index)
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = false

        addSubview(view)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
        self.addConstraints([leadingConstraint, topConstraint, trailingConstraint, bottomConstraint])
        
    }
    
    fileprivate func loadViewFromXib(_ index: Int) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.xibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[index] as! UIView
    }
    
    var xibName: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    
    func xibViewDidLoaded() {
        
    }
}
