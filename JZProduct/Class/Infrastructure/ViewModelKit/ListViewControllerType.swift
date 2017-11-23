//
//  ListViewControllerType.swift
//  Pods
//
//  Created by JeffZhao on 2016/10/14.
//
//

import Foundation
import UIKit

public protocol ListViewControllerType: class {
    
    func configUIListView()
    
    func configUIRefresh()
    
    func updateUIListView()
    
    func updateUIRefresh(_ loadDataSuccess: Bool)
    
    func refreshData()
    
    func loadMoreData()
    
    func willRefreshData(_ avm: inout ListViewModelType)
    
    func willLoadMoreData(_ avm: inout ListViewModelType)
    
    func didLoadMoreData(_ avm: inout ListViewModelType)
}

extension ListViewControllerType where Self: ViewModelOwnerType {
    
    var listViewModel: ListViewModelType {
        get {
            let obj: ListViewModelType? = viewModel()
            assert(obj != nil, "ViewModel需要遵循ListViewModelType协议")
            return obj!
        }
        set {
            setViewModel(newValue)
        }
    }
    
    var paginatorEnabled: Bool {
        return listViewModel.paginatorEnabled
    }
    
    var hasMoreData: Bool {
        return listViewModel.hasMoreData
    }
    
    var isReloading: Bool {
        return listViewModel.reloading
    }
    
    var isLoadingMore: Bool {
        return listViewModel.loadingMore
    }
}
