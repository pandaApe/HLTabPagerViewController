//
//  HLTabScrollView.swift
//  HLTabPagerViewController
//
//  Created by PandaApe (whailong2010@gmail.com) on 5/29/17.
//  Copyright © 2017 PandaApe. All rights reserved.
//

import Foundation
import UIKit

protocol HLTabScrollDelegate{
    
    func tabScrollView(_ tabScrollView: HLTabScrollView, didSelectTabAtIndex index: Int) -> Void
}

class HLTabScrollView: UIScrollView {
    
    fileprivate var tabViews: [UIView]!
    fileprivate var tabsView: UIView!
    fileprivate var tabIndicator: UIView?
    fileprivate var tabsLeadingConstraint: NSLayoutConstraint!
    fileprivate var tabsTrailingConstraint: NSLayoutConstraint!
    fileprivate var indicatorWidthConstraint: NSLayoutConstraint!
    fileprivate var indicatorCenterConstraint: NSLayoutConstraint!
    
    var tabScrollDelegate:HLTabScrollDelegate?
    
}

extension HLTabScrollView {
    
     func selectTab(atIndex index:Int, animated:Bool = true) {
        
        var animatedDuration:CGFloat = 0.0;
        
        if animated {
            
            animatedDuration = 0.4
        }
        
        self.indicatorCenterConstraint  = self.replace(constraint: self.indicatorCenterConstraint, withNewToItem: self.tabViews[index])
        self.indicatorWidthConstraint   = self.replace(constraint: self.indicatorWidthConstraint, withNewToItem: self.tabViews[index])
        
        UIView.animate(withDuration: TimeInterval(animatedDuration)) {
            
            self.layoutIfNeeded()
            self.scrollToSelectedTab()
        }
    }
}

extension HLTabScrollView {
    
    convenience init(frame: CGRect, tabViews: [UIView], color: UIColor, bottomLineHeight: CGFloat, selectedTabIndex index: Int = 0) {
        self.init(frame: frame)
        
        self.showsHorizontalScrollIndicator = false
        self.bounces                        = false
        
        self.tabViews   = tabViews
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints   = false
        self.addSubview(contentView)
        self.tabsView   = contentView
        
        let bottomLine  = UIView(frame: self.bounds)
        bottomLine.translatesAutoresizingMaskIntoConstraints    = false
        bottomLine.backgroundColor                              = color
        self.addSubview(bottomLine)
        
        self.addConstraints(toContentView: contentView,
                            bottomLine: bottomLine,
                            bottomLineHeight: bottomLineHeight)
        self.addTabs(fromTabViews: tabViews, toContentView: contentView)
        self.addIndicators(toContentView: contentView, withColor: color)
        
        self.selectTab(atIndex: index, animated: false)
    }
    
    public override var frame: CGRect{
        
        didSet{
            
            self.setNeedsUpdateConstraints()
            self.scrollToSelectedTab()
        }
    }
    
    override public func updateConstraints() {
        
        var offset:CGFloat = 0
        
        if self.bounds.size.width > self.tabsView.frame.size.width {
            
            offset = (self.bounds.size.width - self.tabsView.frame.size.width)/CGFloat(2.0)
        }
        
        self.tabsLeadingConstraint.constant     = offset
        self.tabsTrailingConstraint.constant    = -offset
        
        super.updateConstraints()
    }
    
    fileprivate func addConstraints(toContentView contentView: UIView, bottomLine: UIView, bottomLineHeight: CGFloat) {
        
        let views = ["contentView": contentView, "bottomLine": bottomLine]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bottomLine]-0-|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: views))
        
        let format = "V:|-0-[contentView]-0-[bottomLine(bottomLineHeight)]-0-|"
        let metrics = ["bottomLineHeight": bottomLineHeight]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format,
                                                           options: [],
                                                           metrics: metrics,
                                                           views: views))
        
        self.addConstraint(NSLayoutConstraint(item: contentView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .height,
                                              multiplier: 1.0,
                                              constant: -bottomLineHeight))
        
        
        self.tabsLeadingConstraint = NSLayoutConstraint(item: contentView,
                                                        attribute: .leading,
                                                        relatedBy: .equal,
                                                        toItem: self,
                                                        attribute: .leading,
                                                        multiplier: 1.0,
                                                        constant: 0)
        
        self.tabsTrailingConstraint = NSLayoutConstraint(item: contentView,
                                                         attribute: .trailing,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .trailing,
                                                         multiplier: 1.0,
                                                         constant: 0)
        
        self.addConstraints([self.tabsTrailingConstraint, self.tabsLeadingConstraint])
    }
    
   fileprivate func addIndicators(toContentView contentView: UIView, withColor color: UIColor) {
        
        let tabIndicator                = UIView()
        tabIndicator.translatesAutoresizingMaskIntoConstraints = false
        tabIndicator.backgroundColor    = color
        contentView.addSubview(tabIndicator)
        self.tabIndicator               = tabIndicator
        
        let format = "V:[tabIndicator(3)]-0-|"
        let views = ["tabIndicator":tabIndicator]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format,
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: views))
        
        
        self.indicatorWidthConstraint = NSLayoutConstraint(item: tabIndicator,
                                                           attribute: .width,
                                                           relatedBy: .equal,
                                                           toItem: self.tabViews.first,
                                                           attribute: .width,
                                                           multiplier: 1.0,
                                                           constant: 10.0)
        
        self.indicatorCenterConstraint = NSLayoutConstraint(item: tabIndicator,
                                                            attribute: .centerX,
                                                            relatedBy: .equal,
                                                            toItem: self.tabViews.first,
                                                            attribute: .centerX,
                                                            multiplier: 1.0,
                                                            constant: 0.0)
        
        contentView.addConstraints([self.indicatorWidthConstraint, self.indicatorCenterConstraint])
    }
    
    
    fileprivate func addTabs(fromTabViews tabViews: [UIView], toContentView contentView: UIView) {
        
        var VFL = "H:|"
        
        var tabViewsDict = [String:UIView]()
        
        for index in 0 ..< tabViews.count {
            
            let tab = tabViews[index]
            tab.translatesAutoresizingMaskIntoConstraints   = false
            tab.isUserInteractionEnabled                    = true
            contentView.addSubview(tab)
            
            VFL += "-10-[T\(index)]"
            tabViewsDict["T\(index)"] = tab
            
            let tabsGapCons = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[T]-0-|",
                                                             options: [],
                                                             metrics: nil,
                                                             views: ["T":tab])
            contentView.addConstraints(tabsGapCons)
            
            let tabTapGes = UITapGestureRecognizer(target: self,
                                                   action: #selector(tabTapHandler(gestureRecognizer:)))
            tab.addGestureRecognizer(tabTapGes)
        }
        
        VFL += "-10-|"
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: VFL,
                                                                  options: [],
                                                                  metrics: nil,
                                                                  views: tabViewsDict))
    }
    
     func tabTapHandler(gestureRecognizer: UITapGestureRecognizer) {
        
        let index = self.tabViews.index(of: gestureRecognizer.view!)!
        self.tabScrollDelegate?.tabScrollView(self, didSelectTabAtIndex: index)
        
        self.selectTab(atIndex: index)
    }
    
    fileprivate func replace(constraint oldConstraint: NSLayoutConstraint, withNewToItem itemView: UIView) -> NSLayoutConstraint {
        
        let newConstraint = NSLayoutConstraint(item: oldConstraint.firstItem,
                                               attribute: oldConstraint.firstAttribute,
                                               relatedBy: oldConstraint.relation,
                                               toItem: itemView,
                                               attribute: oldConstraint.secondAttribute,
                                               multiplier: oldConstraint.multiplier,
                                               constant: oldConstraint.constant)
        
        newConstraint.priority          = oldConstraint.priority
        newConstraint.shouldBeArchived  = oldConstraint.shouldBeArchived
        newConstraint.identifier        = oldConstraint.identifier
        
        NSLayoutConstraint.deactivate([oldConstraint])
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
    
   fileprivate func scrollToSelectedTab()  {
        
        guard let tabIndicator = self.tabIndicator else {
            return;
        }
        
        let indicatorRect   = tabIndicator.convert(tabIndicator.bounds, to: self.superview)
        
        var diff:CGFloat    = 0
        
        if indicatorRect.origin.x < 0 {
            
            diff = indicatorRect.origin.x - 5
            
        }else if indicatorRect.maxX > self.frame.size.width {
            
            diff = indicatorRect.maxX  - self.frame.size.width + 5
        }else {
            
            diff = 0
        }
        
        if diff != 0 {
            
            let xOffset = self.contentOffset.x + diff
            self.contentOffset = CGPoint(x: xOffset, y: self.contentOffset.y)
        }
    }
    
}
