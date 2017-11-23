//
//  OwnerType.swift
//  Pods
//
//  Created by JeffZhao on 16/9/23.
//
//

import Foundation
import RxSwift

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private var viewModelKey = "ViewModelKit/ViewModelKey"

public protocol ViewModelOwnerType: class {
    func setViewModel(_ vm: ViewModelType)
    func viewModel<E>() -> E?
}

public extension ViewModelOwnerType {
    
    func setViewModel(_ vm: ViewModelType) {
        if var cvm = vm as? ListViewModelType, let lvm = indirectViewModel() as? ListViewModelType  {
            cvm.reloading = lvm.reloading
            cvm.loadingMore = lvm.loadingMore
            setAssociatedObject(object: self, value: cvm, key: &viewModelKey)
        } else {
            setAssociatedObject(object: self, value: vm, key: &viewModelKey)
        }
    }
    
    func viewModel<E>() -> E? {
        return getAssociatedObject(object: self, key: &viewModelKey)
    }
    
    func indirectViewModel() -> ViewModelType? {
        return getAssociatedObject(object: self, key: &viewModelKey)
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public protocol ViewModelGenerationType: ViewModelOwnerType {
    
    associatedtype VMT: ViewModelType
}

public extension ViewModelGenerationType {
    
    var viewModel: VMT {
        return getAssociatedObject(object: self, key: &viewModelKey, initialiser: { VMT.Empty })!
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private var cellModelKey = "ViewModelKit/CellModelKey"

public protocol CellModelOwnerType: class {
    
    func setCellModel(_ cm: CellModelType)
    
    func cellModel<E>() -> E?
}

public extension CellModelOwnerType {
    
    func setCellModel(_ cm: CellModelType) {
        setAssociatedObject(object: self, value: cm, key: &cellModelKey)
    }
    
    func cellModel<E>() -> E? {
        return getAssociatedObject(object: self, key: &cellModelKey)
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


public protocol CellModelGenerationType: CellModelOwnerType {
    
    associatedtype CMT: CellModelType
}

public extension CellModelGenerationType {
    
    var cellModel: CMT {
        if let cm: CMT = cellModel() {
            return cm
        } else {
            let emptyCM = CMT.Empty
            setCellModel(emptyCM)
            return emptyCM
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public protocol BagOwnerType {
    var bag: DisposeBag { get set }
}
