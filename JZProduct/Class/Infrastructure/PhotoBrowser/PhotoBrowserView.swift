//
//  PhotoBrowserView.swift
//  UFace
//
//  Created by JeffZhao on 2017/2/4.
//  Copyright © 2017年 JeffZhao. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

@objc protocol PhotoBrowserCellDelegate: NSObjectProtocol {
    
    @objc optional func longPress(cell: PhotoBrowserCell)
}

class PhotoBrowserCell: UICollectionViewCell, ClassIdentify {
    
    @IBOutlet weak var zoomImageView: ZoomImageView!
    
    var cellModel: PhotoBrowserCellModel?
    
    weak var delegate: PhotoBrowserCellDelegate?
    
    lazy var hud: MBProgressHUD = {
        let view = MBProgressHUD(view: self)
        view.mode = .annularDeterminate
        view.removeFromSuperViewOnHide = false
        self.addSubview(view)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        zoomImageView.delegate = self
    }
    
    func updateUI(_ aCellModel: PhotoBrowserCellModel) {
        cellModel = aCellModel
        if aCellModel.progress < 1.0 {
            hud.show(animated: true)
            hud.progress = aCellModel.progress
        } else {
            hud.hide(animated: false)
        }
        zoomImageView.setImage(url: aCellModel.imageURL,
                           placeholderImage: aCellModel.thumbImage,
                           progress: { [weak self] progress in
                            aCellModel.progress = Float(progress)
                            self?.hud.progress = Float(progress)
                            },
                           completed: { [weak self] error in
                            self?.hud.hide(animated: true)
                            if let _ = error {
                                aCellModel.progress = 0
                            } else {
                                aCellModel.progress = 1
                            }
                            })
        
    }
    
    
}

extension PhotoBrowserCell: QMUIZoomImageViewDelegate {
    
    func singleTouch(inZooming zoomImageView: QMUIZoomImageView, location: CGPoint) {
        
    }
    
//    func doubleTouch(inZooming zoomImageView: QMUIZoomImageView, location: CGPoint)
//    func longPress(inZooming zoomImageView: QMUIZoomImageView)
    
    func enabledZoomView(in zoomImageView: QMUIZoomImageView) -> Bool {
        return true
    }
    
    func longPress(inZooming zoomImageView: QMUIZoomImageView) {
        delegate?.longPress?(cell: self)
    }
}
