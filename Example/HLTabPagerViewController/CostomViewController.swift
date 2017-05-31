//
//  CostomViewController.swift
//  Demo
//
//  Created by PandaApe (whailong2010@gmail.com) on 2017/5/31.
//  Copyright © 2017年 PandaApe. All rights reserved.
//

import UIKit

class CostomViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func viewForTab(atIndex index: Int) -> UIView {
        
        let label           = UILabel()
        label.text          = dataArray[index].title
        label.textAlignment = .center
        label.textColor     = UIColor.black
        label.sizeToFit()
        
        var frame           = label.frame
        frame.size.width    = max(frame.size.width + 20, 85)
        label.frame         = frame
        return label
    }
    

}
