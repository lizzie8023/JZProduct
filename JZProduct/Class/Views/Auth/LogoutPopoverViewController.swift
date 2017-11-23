//
//  LogoutPopoverViewController.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/7/20.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import Foundation
import UIKit

class LogoutPopoverViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var userTitle = ""
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBAction func onLogoutAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        ServiceCenter.auth.logoutUser()
        ViewManager.showLoginView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEmailLabel.text = userTitle
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.superview?.layer.cornerRadius = 0.0
        super.viewWillAppear(animated)
    }
}

