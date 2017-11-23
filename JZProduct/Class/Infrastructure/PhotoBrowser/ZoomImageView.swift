//
//  ZoomImageView.swift
//  UFace
//
//  Created by JeffZhao on 2017/2/4.
//  Copyright © 2017年 JeffZhao. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ZoomImageView: QMUIZoomImageView {
    
    func setImage(url: WebImageURLConvertible, placeholderImage: UIImage?, progress:((Double) -> ())?, completed: ((Error?) -> Void)?) {
        self.image = placeholderImage
        self.imageView.kf.setImage(with: url.asURL(), placeholder: placeholderImage, options: [.transition(.fade(0.3))], progressBlock: { receivedSize, totalSize in
            progress?(Double(receivedSize) / Double(totalSize))
        }, completionHandler: { [weak self] image, error, cacheType, imageURL in
            if let image = image {
                self?.image = image
            }
            completed?(error)
        })
    }
}
