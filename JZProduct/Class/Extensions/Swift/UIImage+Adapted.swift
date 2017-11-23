//
//  UIImage+Adapted.swift
//  Pods
//
//  Created by JeffZhao on 2017/7/10.
//
//

import Foundation
import JZSwiftWarpper
import UIKit

extension JZStudio where Base: UIImage {
    
    var fixedOrientation: UIImage? {
        return self.base.fixedOrientationImage()
    }
    
    
}


extension UIImage {
    
    public func fixedOrientationImage() -> UIImage? {
        let image = self
        guard image.imageOrientation == .up else { return image }
        let imageSize = image.size
        guard let aCGImage = image.cgImage else { return image }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = .identity
        switch image.imageOrientation {
        case .down,.downMirrored:
            transform = transform.translatedBy(x: imageSize.width, y: imageSize.height)
            transform = transform.rotated(by: .pi)
        case .left,.leftMirrored:
            transform = transform.translatedBy(x: imageSize.width, y: 0)
            transform = transform.rotated(by: .pi)
        case .right,.rightMirrored:
            transform = transform.translatedBy(x: 0, y: imageSize.height)
            transform = transform.rotated(by: -.pi)
        default:
            break
        }
        switch image.imageOrientation {
        case .upMirrored,.downMirrored:
            transform = transform.translatedBy(x: imageSize.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored,.rightMirrored:
            transform = transform.translatedBy(x: imageSize.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let colorSpace = aCGImage.colorSpace,
            let ctx = CGContext(data: nil, width: Int(imageSize.width), height: Int(imageSize.height), bitsPerComponent: aCGImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: aCGImage.bitmapInfo.rawValue) else {
                return image
        }
        ctx.concatenate(transform)
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(aCGImage, in: CGRect(x: 0, y: 0, width: imageSize.height, height: imageSize.width))
            break
        default:
            ctx.draw(aCGImage, in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
            break
        }
        // And now we just create a new UIImage from the drawing context
        guard let cgimg = ctx.makeImage() else {
            return image
        }
        return UIImage(cgImage: cgimg)

    }
    
    class func fixOrientation(_ aImage: UIImage?) -> UIImage? {
        guard let image = aImage else { return aImage }
        return image.fixedOrientationImage()
    }
    
}

