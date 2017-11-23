//
//  ForceType.swift
//  Pods
//
//  Created by JeffZhao on 16/9/23.
//
//

import Foundation

/// normal vc must conform
public typealias ForceViewModelType = ViewControllerType & ViewModelGenerationType
/// tableview/collectionview cell must conform
public typealias ForceCellModelType = CellType & CellModelGenerationType
