//
//  WebImage.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/7/20.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import Foundation
import Kingfisher

struct WebImage {
    static func clear() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }
    static func clearMemoryCache() {
        ImageCache.default.clearMemoryCache()
    }
}

protocol WebImageURLConvertible {
    func asURL() -> URL?
    func asImageURL() -> URL?
}

extension String: WebImageURLConvertible {
    
    func asURL() -> URL? {
        return URL(string: self)
    }
    
    func asImageURL() -> URL? {
        return URL(string: self.appending("?imageView2/2/w/800/h/800/format/jpg/q/80"))
    }
}

extension URL: WebImageURLConvertible {
    
    func asURL() -> URL? {
        return self
    }
    
    func asImageURL() -> URL? {
        return URL(string: self.absoluteString.appending("?imageView2/2/w/800/h/800/format/jpg/q/80"))
    }
}

extension UIImageView {
    
    func setImage(stringUrl: String, placeholderImage: UIImage? = nil) {
        
        kf.setImage(with: URL(string: stringUrl) ?? URL(fileURLWithPath: ""), placeholder: placeholderImage, options: [.transition(.fade(0.3))], progressBlock: nil, completionHandler: nil)
    }
    
    func setImage(url: WebImageURLConvertible, placeholderImage: UIImage? = nil) {
        
        kf.setImage(with: url.asImageURL(), placeholder: placeholderImage, options: [.transition(.fade(0.3))], progressBlock: nil, completionHandler: nil)
    }
}

extension WebImageView {
    
    /// 带有颜色遮罩的加载方法
    func setImage(url: WebImageURLConvertible, placeholderImage: UIImage? = nil, tintColor: UIColor? = nil, placeholderImageMode: UIViewContentMode = .scaleAspectFill, imageMode: UIViewContentMode = .scaleAspectFill) {
        let options: KingfisherOptionsInfo
        if let tintColor = tintColor {
            options = [.transition(.fade(0.3)),.processor(TintImageProcessor(tint: tintColor))]
        } else {
            options = [.transition(.fade(0.3))]
        }
        let imageView = self
        imageView.contentMode = placeholderImageMode
        imageView.setWebImageState(.loading)
        imageView.setProgress(0)
        imageView.kf.setImage(
            with: url.asImageURL(),
            placeholder: placeholderImage,
            options: options,
            progressBlock: {
                [weak imageView] receivedSize, expectedSize in
                let progress = Float(receivedSize) / Float(expectedSize)
                imageView?.setProgress(progress)
            },
            completionHandler: {
                [weak imageView] image, error, cacheType, imageURL in
                guard imageView?.kf.webURL?.absoluteString == imageURL?.absoluteString else {
                    return
                }
                if image != nil {
                    imageView?.setWebImageState(.normal)
                    imageView?.contentMode = imageMode
                } else {
                    imageView?.setWebImageState(.loadFailed)
                }
        })
    }
}
