//
//  LoadMoreAnimation.swift
//  Pods
//
//  Created by JeffZhao on 2016/11/16.
//
//

import Foundation
import UIKit

class LoadMoreAnimationView: UIActivityIndicatorView {
    
}

extension LoadMoreAnimationView: AnimationViewType {
    
    func play() {
        
    }
    
    func pause() {
        stopAnimating()
    }
    
    func setAnimationProgress(progress: CGFloat) {
        startAnimating()
    }
    
}
