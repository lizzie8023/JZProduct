//
//  PushPopBlendSegue.swift
//  JZProduct
//
//  Created by JeffZhao on 2017/10/20.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

import UIKit

class PushAfterPopByCountSegue: UIStoryboardSegue {
    
    @IBInspectable var count: Int = 1
    
    override func perform() {
        guard let navc = self.source.navigationController else { return }
        let vcs = navc.viewControllers
        guard vcs.count > count else { return }
        var nvcs = vcs.dropLast(count)
        nvcs.append(self.destination)
        navc.setViewControllers(Array(nvcs), animated: true)
    }
}

class PushAfterPopByIdentifySegue: UIStoryboardSegue {
    
    var classIdentify = ""
    
    override func perform() {
        guard let navc = self.source.navigationController else { return }
        let vcs = navc.viewControllers
        if let vc = (vcs.filter{  NSStringFromClass($0.classForCoder) == classIdentify }).last,
            let index = vcs.index(of: vc){
            var nvcs = vcs.dropLast(vcs.count - index)
            nvcs.append(self.destination)
            navc.setViewControllers(Array(nvcs), animated: true)
        }else{
            var nvcs = vcs
            nvcs.append(self.destination)
            navc.setViewControllers(Array(nvcs), animated: true)
        }
    }
}
