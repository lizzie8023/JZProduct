//
//  View.swift
//  Pods
//
//  Created by JeffZhao on 16/9/23.
//
//

import Foundation
import UIKit
import RxSwift

open class TableViewCell: UITableViewCell, ClassIdentify, BagOwnerType {
    
    public var bag = DisposeBag()
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
}

open class CollectionViewCell: UICollectionViewCell, ClassIdentify, BagOwnerType {
    
    public var bag = DisposeBag()
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}

open class CollectionReusableView: UICollectionReusableView, ClassIdentify, BagOwnerType {
    
    public var bag = DisposeBag()
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    
}


