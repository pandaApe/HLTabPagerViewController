//
//  BaseViewController.swift
//  Demo
//
//  Created by PandaApe on 2017/5/31.
//  Copyright © 2017年 PandaApe. All rights reserved.
//

import UIKit
import HLTabPagerViewController

class BaseViewController: HLTabPagerViewController {
    
    var dataArray = [(title:String, bgColor:UIColor)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for index in 0 ... 10 {
            
            dataArray.append((title: "Tab-\(index)", bgColor: generateRandomColor()))
        }
        
        self.dataSource = self
        self.delegate = self
        
        self.reloadData()
        
    }
}


extension BaseViewController: HLTabPagerDataSource, HLTabPagerDelegate {
    
    func numberOfViewControllers() -> Int{
        
        return dataArray.count
    }
    
    func viewController(forIndex index:Int) -> UIViewController{
        
        let contentVC = T1ViewController()
        
        contentVC.view.backgroundColor = dataArray[index].bgColor
        
        return contentVC
    }
    
    
    func tabHeight() -> CGFloat {
        return 45
    }
    
    func tabColor() -> UIColor {
        return UIColor.gray
    }
    
    //    func tabBackgroundColor() -> UIColor {
    //        return UIColor.white
    //    }
    
    func bottomLineHeight() -> CGFloat {
        return 2
    }
    
    
    func tabPager(_ tabPager: HLTabPagerViewController, willTransitionToTab atIndex: Int) {
        
        print("willTransitionToTab ->\(atIndex)")
        
    }
    
    func tabPager(_ tabPager: HLTabPagerViewController, didTransitionToTab atIndex: Int) {
        
        print("didTransitionToTab  ->\(atIndex)")
        
    }
    
    
    
}

func generateRandomColor() -> UIColor {
    
    let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
    let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
    let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
    
    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
}

