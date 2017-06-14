//
//  HLTabPagerDataSource.swift
//  Demo
//
//  Created by PandaApe (whailong2010@gmail.com) on 5/30/17.
//  Copyright © 2017 PandaApe. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol HLTabPagerDataSource: NSObjectProtocol{
    
    
    func numberOfViewControllers() -> Int
    
    func viewController(forIndex index: Int) -> UIViewController
    
    @objc optional func viewForTab(atIndex index: Int) -> UIView
    
    @objc optional func titleForTab(atIndex index: Int) -> String
    
    @objc optional func tabHeight() -> CGFloat
    
    @objc optional func tabColor() -> UIColor
    
    @objc optional func tabBackgroundColor() -> UIColor
    
    @objc optional func titleFont() -> UIFont
    
    @objc optional func titleColor() -> UIColor
    
    @objc optional func bottomLineHeight() -> CGFloat
    
}
