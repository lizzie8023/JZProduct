//
//  RefreshAnimation.swift
//  Pods
//
//  Created by JeffZhao on 2016/11/16.
//
//

import Foundation
import UIKit

// MARK: - DefaultRefreshAnimationView

public final class DefaultRefreshAnimationView: UIView {
    
    let imageView = UIImageView(image: UIImage(named: "refresh_arrow_down"))
    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        addSubview(imageView)
        frame = imageView.bounds
        
        indicatorView.center = imageView.center
        indicatorView.hidesWhenStopped = true
        indicatorView.stopAnimating()
        addSubview(indicatorView)
    }
}

extension DefaultRefreshAnimationView: AnimationViewType {
    
    public func play() {
        imageView.isHidden = true
        indicatorView.startAnimating()
    }
    
    public func pause() {

    }
    
    public func setAnimationProgress(progress: CGFloat) {
        imageView.isHidden = false
        indicatorView.stopAnimating()
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                options: [.beginFromCurrentState, .curveLinear],
                animations: {
                    if progress == 1 {
                        self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                    } else {
                        self.imageView.transform = CGAffineTransform.identity
                    }
                },
                completion: nil)
    }
}

