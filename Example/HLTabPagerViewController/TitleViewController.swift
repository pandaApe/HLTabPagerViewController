//
//  ViewController.swift
//  Demo
//
//  Created by PandaApe (whailong2010@gmail.com) on 5/30/17.
//  Copyright © 2017 PandaApe. All rights reserved.
//

import UIKit

class TitleViewController: BaseViewController {
    
    func titleForTab(atIndex index: Int) -> String {
        
        return dataArray[index].title
    }
}

