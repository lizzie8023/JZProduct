//
//  ConstValues.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/8/18.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import Foundation
import SwiftyJSON

enum City: Int {
    case beijing = 1
    case shanghai = 2
    
    var name: String {
        switch self {
        case .beijing:
            return "北京"
        case .shanghai:
            return "上海"
        }
    }
}

struct ExtraInfo {
    var city: City {
        return .beijing
    }
    var jsonString: String {
        do {
            let target = ["place": city.rawValue]
            let jsonData = try JSONSerialization.data(withJSONObject: target, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            Log.info(error.localizedDescription)
            return ""
        }
    }
    
    init() {

    }
}

