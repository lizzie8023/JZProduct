//
//  PhotoBrowserViewModel.swift
//  UFace
//
//  Created by JeffZhao on 2017/2/4.
//  Copyright © 2017年 JeffZhao. All rights reserved.
//

import Foundation
import RxSwift

class PhotoBrowserViewModel {
    
    var items = [PhotoBrowserCellModel]()
    
    var index = 0
    
    var isEmpty: Bool {
        return true
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsIn(_ section: Int) -> Int {
        return items.count
    }
    
    func cellModelAt(_ indexPath: IndexPath) -> PhotoBrowserCellModel {
        return items[indexPath.row]
    }
    
    func indexOf(_ cellModel: PhotoBrowserCellModel?) -> Int? {
        guard let cellModel = cellModel else { return nil }
        return items.index(of: cellModel)
    }
    
    func cellIdentifierAt(_ indexPath: IndexPath) -> String {
        return PhotoBrowserCell.reuseIdentifier
    }
    
    func setPhotos(_ photos: [PhotoType]) {
        items = photos.map(PhotoBrowserCellModel.init)
    }
    
    var defaultIndexPath: IndexPath {
        return IndexPath(item: index, section: 0)
    }

    
}

class PhotoBrowserCellModel: Equatable {
    
    let photo: PhotoType
    
    var progress: Float = 0
    
    init(_ aPhoto: PhotoType) {
        photo = aPhoto
    }
    
    var imageURL: String {
        return photo.imageURL
    }
    
    var thumbImage: UIImage? {
        return photo.thumbImage
    }
    
    static func ==(lhs: PhotoBrowserCellModel, rhs: PhotoBrowserCellModel) -> Bool {
        return lhs.imageURL == rhs.imageURL
    }
}
