//
//  ViewType.swift
//  Pods
//
//  Created by JeffZhao on 16/9/23.
//
//

import Foundation
import UIKit
import RxSwift

public protocol CellType {
    
    func updateUI(cellModel: CellModelType)
    
    func updateUI()
    
    func updateUI(_ cellModel: CellModelType)
}

extension CellType where Self: CellModelOwnerType {
    
    public func updateUI(cellModel: CellModelType) {
        setCellModel(cellModel)
        updateUI()
    }
    
    func updateUI(_ cellModel: CellModelType) {
        setCellModel(cellModel)
        updateUI()
    }
}
