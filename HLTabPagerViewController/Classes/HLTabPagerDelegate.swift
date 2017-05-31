//
//  HLTabPagerDelegate.swift
//  Demo
//
//  Created by PandaApe (whailong2010@gmail.com) on 5/30/17.
//  Copyright © 2017 PandaApe. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol HLTabPagerDelegate: NSObjectProtocol{
    
    @objc optional func tabPager(_ tabPager: HLTabPagerViewController, willTransitionToTab atIndex: Int)
    
    @objc optional func tabPager(_ tabPager: HLTabPagerViewController, didTransitionToTab atIndex: Int)
    
}
