//
//  ModelType.swift
//  Pods
//
//  Created by JeffZhao on 16/9/23.
//
//

import Foundation
import SwiftyJSON
import RxSwift

public func viewModelTuple<E>(_ model: E) -> (JSON) -> ViewModelTuple<E> {
    return { json in
        return ViewModelTuple(json, model)
    }
}

public final class ViewModelTuple<E> {
    let json: JSON
    let model: E
    init(_ ajson: JSON, _ amodel: E) {
        json = ajson
        model = amodel
    }
}

/// default model protocol
public protocol ModelType {
    init(_ json: JSON)
}

public extension ModelType {
    /// empty instance
    static var Empty: Self {
        return self.init(JSON.empty)
    }
}

public protocol ViewModelType: ModelType {
    
    func loading() -> Observable<ViewModelType>
    
    var isEmpty: Bool { get }
}

public protocol ListViewModelType: ViewModelType {
    
    func numberOfSections() -> Int
    func numberOfItemsIn(_ section: Int) -> Int
    func cellModelAt(_ indexPath: IndexPath) -> CellModelType
    func cellIdentifierAt(_ indexPath: IndexPath) -> String
    
    var reloading: Bool { get set }
    var refreshEnabled: Bool { get set }
    func prepareForReloading()
    
    var loadingMore: Bool { get set }
    var paginatorEnabled: Bool { get set }
    var hasMoreData: Bool { get }
    
    var cursor: String { get set }
    
    var loadDataSuccessed: Bool { get set }
}

public extension ListViewModelType {
    
    var allowUseURLCache: Bool {
        return !reloading && !loadingMore
    }
}

public protocol CellModelType: ModelType {
    
}

protocol JSONConvertibleType: ModelType {
    var jsonValue: JSON { get }
    var jsonString: String { get }
}

extension JSONConvertibleType {
    var jsonString: String {
        if let dic = jsonValue.dictionaryObject,
            let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted),
            let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
            return string as String
        }
        return ""
    }
}
