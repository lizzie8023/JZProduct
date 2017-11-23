//
//  VarCenter.swift
//  JZProduct
//
//  Created by JeffZhao on 8/11/17.
//  Copyright © 2017 JZ Studio. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift
import ConciseKit

typealias VarCenterTuple = (type: CategoryType, id: Int, name: String)

public enum CategoryType: String {
    case all = ""
}

extension CategoryType {
    func setId(_ id: Int) -> VarCenterTuple {
        let name = VarCenter.default.name(self, and: id)
        return (self, id, name)
    }
}


final class VarCenter {
    static let `default` = VarCenter()
    private var bag = DisposeBag()
    private var categorys: NSMutableDictionary = [:]
    
    
    private init() {
        if let data = UserDefaults.standard.value(forKey: "kJZServiceVar"), let d = data as? Data, let dictionary = NSKeyedUnarchiver.unarchiveObject(with: d) as? NSMutableDictionary {
            categorys = dictionary
        }
    }
    
    /// 获取服务端定义变量
    public func refreshVarFromService() {
        //REQUEST HERE
        
    }
    
    private func saveCategory() {
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: self.categorys)
        UserDefaults.standard.set(data, forKey: "kJZServiceVar")
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func name(_ fromType: CategoryType, and id: Int) -> String {
        if let arr = self.categorys[fromType.rawValue], let items = arr as? NSArray {
            for item in items {
                if let item = item as? JZCategory, item.id == id {
                    return item.name
                }
            }
        }
        return ""
    }
}

class JZCategory: NSObject, NSCoding {
    let name: String
    let id: Int
    
    init(_ json: JSON) {
        name = json["name"].stringValue
        id = json["id"].intValue
    }
    
    convenience init(_ city: City) {
        let json = JSON(["name": city.name, "id": city.rawValue])
        self.init(json)
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let id = aDecoder.decodeInteger(forKey: "id")
        let json = JSON("{name: \(name), id: \(id)}")
        self.init(json)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: "name")
        aCoder.encode(id, forKey: "id")
    }
    
}
