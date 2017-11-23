//
//  PhotoBrowserViewController.swift
//  UFace
//
//  Created by JeffZhao on 2017/2/4.
//  Copyright © 2017年 JeffZhao. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import MBProgressHUD
import Toaster

protocol PhotoType: class {
    var imageURL: String { get }
    var thumbImageURL: String { get }
    var thumbImage: UIImage? { get }
}

@objc protocol PhotoBrowserDelegate: NSObjectProtocol {
    
    @objc optional func photoBrowser(_ browser: PhotoBrowserViewController, didShowItemAt: Int)
    
    @objc optional func photoBrowser(browser: PhotoBrowserViewController, didDeleteItem: Any?)
}

class PhotoBrowserViewController: ViewController {
    
    let viewModel = PhotoBrowserViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: PhotoBrowserDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 20)
        DispatchQueue.main.async(execute: scrollToDefaultItem)
        updateNavigationBarAlpha(0)
    }
    
    func scrollToDefaultItem() {
        navigationItem.title = "1/\(viewModel.items.count)"
        if !collectionView.indexPathsForVisibleItems.contains(viewModel.defaultIndexPath) {
            collectionView.contentOffset = CGPoint(x: CGFloat(viewModel.index) * collectionView.bounds.width, y: 0)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setPhotos(photos: [PhotoType], index: Int = 0) {
        viewModel.setPhotos(photos)
        viewModel.index = index
    }
    
    class func create() -> PhotoBrowserViewController {
        return UIStoryboard(name: storyboardIdentifier, bundle: Bundle.main).instantiateViewController(withIdentifier: viewControllerIdentifier) as! PhotoBrowserViewController
    }
    
    override class var storyboardIdentifier: String {
        return "PhotoBrowser"
    }
    
    class var viewControllerIdentifier: String {
        return String(describing: self)
    }
}

extension PhotoBrowserViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationItem.title = "\(Int(scrollView.contentOffset.x / scrollView.frame.width) + 1)/\(viewModel.items.count)"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsIn(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifierAt(indexPath), for: indexPath) as! PhotoBrowserCell
        cell.updateUI(viewModel.cellModelAt(indexPath))
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.screenWidth, height: ScreenSize.screenHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.photoBrowser?(self, didShowItemAt: indexPath.item)
    }
}

import Kingfisher

extension PhotoBrowserViewController: PhotoBrowserCellDelegate {

    func longPress(cell: PhotoBrowserCell) {
        
        if let imageURL = cell.cellModel?.imageURL, ImageCache.default.imageCachedType(forKey: imageURL).cached {
            let actionSheet = UIAlertController(style: .actionSheet, title: nil, message: nil)
            actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "保存", style: .default, handler: { _ in
                if let img = ImageCache.default.retrieveImageInDiskCache(forKey: imageURL) {
                    ViewManager.saveImageToPhotoAlbum(image: img, completion: { result in
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.mode = .text
                        if result {
                            hud.label.text = "保存成功"
                        } else {
                            hud.label.text = "保存失败"
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                            hud.hide(animated: true)
                        })
                    })
                }
            }))
            present(actionSheet, animated: true, completion: nil)
        }
    }
}
