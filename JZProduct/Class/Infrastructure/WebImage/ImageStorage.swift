//
//  ImageStorage.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/7/21.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import Foundation
import UIKit

/// 从Bundle中加载图片
struct ImageStorage {
    
    enum FileBundle {
        case main(String)
        case cls(AnyClass, String)
        var path: String? {
            switch self {
            case let .main(bundleName):
                return Bundle.main.path(forResource: bundleName, ofType: "bundle")
            case let .cls(cls, bundleName):
                return Bundle(for: cls).path(forResource: bundleName, ofType: "bundle")
            }
        }
    }
    
    static func image(fileBundle: FileBundle, imageName: String, ext: String = "jpg") -> UIImage? {
        if let rootPath = fileBundle.path {
            return UIImage(contentsOfFile: rootPath.jz.stringByAppendingPathComponent("\(imageName).\(ext)"))
        }
        return nil
    }
}
