//
//  Model.swift
//  Pods
//
//  Created by JeffZhao on 16/9/25.
//
//

import Foundation
import SwiftyJSON
import RxSwift

extension String {
    
    static let emptyCursor = "EmptyCursor"
    
    var isEmptyCursor: Bool {
        return self == String.emptyCursor
    }
}

open class ListViewModel: ListViewModelType {
    
    public required init(_ json: JSON) {
        cursor = json["cursor"].stringValue
        hasMoreData = json["more"].boolValue
    }
    
    open var isEmpty: Bool {
        return true
    }

    open func loading() -> Observable<ViewModelType> {
        return Observable.never()
    }

    open func numberOfSections() -> Int {
        return 1
    }
    
    open func numberOfItemsIn(_ section: Int) -> Int {
        return 0
    }
    
    open func cellModelAt(_ indexPath: IndexPath) -> CellModelType {
        return CellModel.Empty
    }
    
    open func cellIdentifierAt(_ indexPath: IndexPath) -> String {
        return TableViewCell.reuseIdentifier
    }
    
    open func prepareForReloading() {
        reloading = true
        cursor = String.emptyCursor
    }
    
    open var reloading = false
    open var refreshEnabled = false
    
    open var loadingMore = false
    open var paginatorEnabled = false
    open var hasMoreData = false
    
    open var cursor: String = String.emptyCursor
    
    open var loadDataSuccessed: Bool = false
}

open class CellModel: CellModelType {
    
    public required init(_ json: JSON) {
     
    }
    
}
