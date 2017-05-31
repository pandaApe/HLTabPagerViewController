//
//  HLTabPagerViewController.swift
//  HLTabPagerViewController
//
//  Created by PandaApe (whailong2010@gmail.com) on 5/30/17.
//  Copyright © 2017 PandaApe. All rights reserved.
//

import Foundation
import UIKit

open class HLTabPagerViewController: UIViewController {
    
    open weak var dataSource: HLTabPagerDataSource?
    open weak var delegate: HLTabPagerDelegate?
    
    open var selectedIndex = 0
    
    fileprivate var tabTitles = [String]()
  
    fileprivate var headerScrollView: HLTabScrollView?
    
    fileprivate var viewControllers = [UIViewController]()
    
    fileprivate var headerColor = UIColor.clear
    
    fileprivate var tabBackgroundColor = UIColor.clear
    
    fileprivate var headerHeight: CGFloat = 0.0
    
    fileprivate let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: nil)
    
    open func reloadData()  {
        
        guard let dataSource = self.dataSource else {
            
            fatalError("Not implement data Source")
        }
        
        if self.dataSource?.numberOfViewControllers() == 0 {
            print("number of child view controllers is ZERO.")
            return
        }
        
        self.view.removeConstraints(self.view.constraints)
        
        for index in 0 ..< dataSource.numberOfViewControllers() {
            
            if let viewController = self.dataSource?.viewController(forIndex: index) {
                
                self.viewControllers.append(viewController)
            }
            
            if let title = self.dataSource?.titleForTab?(atIndex: index) {
                
                self.tabTitles.append(title)
            }
        }
        
        self.reloadTabs()
        
        var frame           = self.view.bounds
        frame.origin.y      = self.headerHeight
        frame.size.height   -= self.headerHeight
        
        self.pageViewController.view.frame = frame
        
        self.pageViewController.setViewControllers([self.viewControllers.first!], direction: .reverse, animated: false, completion: nil)
        
        self.selectedIndex = 0
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[header]-0-[pager]-0-|",
                                                                options: [],
                                                                metrics: nil,
                                                                views: ["header": self.headerScrollView!,
                                                                        "pager": self.pageViewController.view]
        ))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pager]-0-|",
                                                                options: [],
                                                                metrics: nil,
                                                                views: ["pager": self.pageViewController.view]))
        
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
   open func selectTabbar(atIndex index: Int, animation: Bool = false) {
        
        self.pageViewController.setViewControllers([self.viewControllers[index]],
                                                   direction: .reverse,
                                                   animated: animation,
                                                   completion: nil)
        
        self.headerScrollView?.selectTab(atIndex: index, animated: animation)
        self.selectedIndex = index
    }

    
    fileprivate func reloadTabs() {
        
        self.setupUI()
        
        var tabViews :[UIView]
        
        if let _ = self.dataSource?.viewForTab {
            
            tabViews = self.addTabsFromViews()
        }else if let _ = self.dataSource?.titleForTab {
            
            tabViews = self.addTabsFromTitles()
        }else {
            
            fatalError("Pls implement either viewForTabAtIndex: or titleForTabAtIndex:")
        }
        
        var frame           = self.view.bounds
        frame.size.height   = self.headerHeight
        
        var bottomLineHeight: CGFloat
        
        if let lineHeight   = self.dataSource?.bottomLineHeight?() {
           
            bottomLineHeight = lineHeight
        }else{
            
            bottomLineHeight = 2.0
        }
        
        self.headerScrollView?.removeFromSuperview()
        self.headerScrollView = HLTabScrollView(frame: frame,
                                       tabViews: tabViews,
                                       color: self.headerColor,
                                       bottomLineHeight: bottomLineHeight,
                                       selectedTabIndex: self.selectedIndex)

        self.headerScrollView?.autoresizingMask   = .flexibleWidth
        
        self.headerScrollView?.backgroundColor    = self.tabBackgroundColor
        
        self.headerScrollView?.tabScrollDelegate  = self
        
        self.view.addSubview(self.headerScrollView!)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[header(headerHeight)]",
                                                                 options: [],
                                                                 metrics: ["headerHeight":self.headerHeight],
                                                                 views: ["header":self.headerScrollView!]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[header]-0-|",
                                                                options: [],
                                                                metrics: nil,
                                                                views: ["header":self.headerScrollView!]))
        
    }
    
    fileprivate func setupUI() {
        
        if let headerHeight = self.dataSource?.tabHeight?() {
            
            self.headerHeight = headerHeight
        }else {
            
            self.headerHeight = 44.0
        }
        
        if let tabColor = self.dataSource?.tabColor?() {
            
            self.headerColor = tabColor
        }else{
            
            self.headerColor = UIColor.orange
        }
        
        if let bgColor = self.dataSource?.tabBackgroundColor?() {
            
            self.tabBackgroundColor = bgColor
        }else{
            
            self.tabBackgroundColor = UIColor(white: 0.95, alpha: 1)
        }
    }
    
    fileprivate func addTabsFromTitles() -> [UIView] {
        
        var tabViews = [UIView]()
        
        var font: UIFont
        
        if let titleFont = self.dataSource?.titleFont {
            
            font = titleFont()
        }else{
            
            font = UIFont(name: "HelveticaNeue-Thin", size: 20)!
        }
        
        var color: UIColor
        
        if let titleColor = self.dataSource?.titleColor {
            
            color = titleColor()
        }else{
            
            color = UIColor.black
        }
        
        for title in self.tabTitles {
            
            let label           = UILabel()
            label.text          = title
            label.textAlignment = .center
            label.font          = font
            label.textColor     = color
            label.sizeToFit()
            
            var frame           = label.frame
            frame.size.width    = max(frame.size.width + 20, 85)
            label.frame         = frame
            tabViews.append(label)
            
        }
        
        return tabViews
    }
    
    fileprivate func addTabsFromViews() -> [UIView] {
        
        var tabViews = [UIView]()
        for index in 0 ..< self.viewControllers.count {
            
            if let view = self.dataSource?.viewForTab?(atIndex: index) {
            
                tabViews.append(view)
            }
        }
        
        return tabViews
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in self.pageViewController.view.subviews {
            
            if let scrollView = view as? UIScrollView {
                
                scrollView.canCancelContentTouches  = true
                scrollView.delaysContentTouches     = false
            }
        }
        
        self.pageViewController.delegate    = self
        self.pageViewController.dataSource  = self
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
    }
}

extension HLTabPagerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let pageIndex = self.viewControllers.index(of: viewController)!
        
        return pageIndex > 0 ? self.viewControllers[pageIndex - 1] : nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let pageIndex = self.viewControllers.index(of: viewController)!

        return (pageIndex < self.viewControllers.count - 1) ? self.viewControllers[pageIndex + 1] : nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        let index = self.viewControllers.index(of: pendingViewControllers.first!)!
        
        self.headerScrollView?.selectTab(atIndex: index)
        
        self.delegate?.tabPager?(self, willTransitionToTab: index)
        
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let selectedViewController  = self.pageViewController.viewControllers?.first
        
        self.selectedIndex          = self.viewControllers.index(of: selectedViewController!)!
        
        self.headerScrollView?.selectTab(atIndex: self.selectedIndex)
        
        self.delegate?.tabPager?(self, didTransitionToTab: self.selectedIndex)
    }
}

extension HLTabPagerViewController: HLTabScrollDelegate {
    
     func tabScrollView(_ tabScrollView: HLTabScrollView, didSelectTabAtIndex index: Int) {
    
        if index != self.selectedIndex {
            
            self.delegate?.tabPager?(self, willTransitionToTab: index)
        }
        
        let direction: UIPageViewControllerNavigationDirection = (index > self.selectedIndex) ? .forward : .reverse
        
        let complectionHandler: (Bool) -> Void = { finished in
        
            if finished {
                
                DispatchQueue.main.async(execute: { 
                    
                    self.pageViewController.setViewControllers([self.viewControllers[index]], direction: direction, animated: false, completion: nil)
                })
            }
            
            self.selectedIndex = index
            self.delegate?.tabPager?(self, didTransitionToTab: index)
        }
        
        self.pageViewController.setViewControllers([self.viewControllers[index]],
                                                   direction: direction,
                                                   animated: true,
                                                   completion: complectionHandler)
    }
}

