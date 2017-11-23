//
//  EmptySignView.swift
//  Pods
//
//  Created by JeffZhao on 2016/10/14.
//
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class EmptySignView: UIView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var actionButton: UIButton!
    
    var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    class func create() -> EmptySignView {
        return UINib(nibName: "EmptySignView", bundle: Bundle(for: EmptySignView.self)).instantiate(withOwner: nil, options: nil).first as! EmptySignView
    }
    
    func with(bundle: Bundle, imageName: String, title: String?, action: (() -> ())?) {
        bag = DisposeBag()
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        imageView.image = image
        let highlightedImage = UIImage(named: imageName + "_hl", in: bundle, compatibleWith: nil) ?? image
        imageView.highlightedImage = highlightedImage
        titleLabel.text = title
        actionButton.rx.tap.asObservable().subscribe(onNext: action).disposed(by: bag)
        actionButton.rx.observe(Bool.self, "highlighted")
            .subscribeOn(MainScheduler.instance)
            .bind {
                [unowned self] in
                self.imageView.isHighlighted = $0 ?? false
            }
            .disposed(by: bag)
    }
}
