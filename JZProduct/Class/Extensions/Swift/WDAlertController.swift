//
//  WDAlertController.swift
//  Thingyan
//
//  Created by Jeff Zhao on 15/11/5.
//  Copyright © 2015年 Phantomex. All rights reserved.
//

import UIKit

class WDAlertController {
    
    static var appRootVC = UIApplication.shared.keyWindow?.rootViewController

    class func show(_ style: UIAlertControllerStyle, title: String?, message: String?, actions: UIAlertAction...) {
        show(style, title: title, message: message, actions: actions)
    }

    class func show(_ style: UIAlertControllerStyle, title: String?, message: String?, actions: [UIAlertAction]) {
        let alertActions: [UIAlertAction]
        if actions.count == 0 {
            alertActions = [UIAlertAction(title: "OK", style: .cancel, handler: nil)]
        } else {
            alertActions = actions
        }
        let alert = UIAlertController(style: style, title: title, message: message, actions: alertActions)
        appRootVC?.present(alert, animated: true, completion: nil)
    }

    class func showAlertWithTextField(_ title: String?, message: String?, completionHandler: ((String?) -> Void)? = nil, actions: UIAlertAction...) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let alertActions: [UIAlertAction]
        if actions.count == 0 {
            alertActions = [UIAlertAction(title: "OK", style: .default, handler: { _ in completionHandler?(alert.textFields?.first?.text) }),
                            UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in completionHandler?(nil) })]
        } else {
            alertActions = actions
        }

        for action in alertActions {
            alert.addAction(action)
        }
        alert.addTextField(configurationHandler: nil)

        appRootVC?.present(alert, animated: true, completion: nil)
    }
}
