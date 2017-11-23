//
//  RootNavigationController.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/7/11.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController, ViewControllerCreatableType {

    static var storyboardIdentifier: String {
        return "Main"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(true, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return visibleViewController?.preferredStatusBarStyle ?? .default
    }
}

import MessageUI

extension RootNavigationController: MFMessageComposeViewControllerDelegate {
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }

}
