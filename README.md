# HLTabPagerViewController

[![CI Status](http://img.shields.io/travis/PandaApe/HLTabPagerViewController.svg?style=flat)](https://travis-ci.org/PandaApe/HLTabPagerViewController)
[![Version](https://img.shields.io/cocoapods/v/HLTabPagerViewController.svg?style=flat)](http://cocoapods.org/pods/HLTabPagerViewController)
[![License](https://img.shields.io/cocoapods/l/HLTabPagerViewController.svg?style=flat)](http://cocoapods.org/pods/HLTabPagerViewController)
[![Platform](https://img.shields.io/cocoapods/p/HLTabPagerViewController.svg?style=flat)](http://cocoapods.org/pods/HLTabPagerViewController)


<img src="example.gif" alt="Animated gif">


## Installation

**CocoaPods** (recommended)

Add the following line to your `Podfile`:

`pod 'HLTabPagerViewController', '~> 0.1.1'`

And then add `import HLTabPagerViewController` to your view controller.

## Usage
To use it, you should create a view controller that extends `HLTabPagerViewController `. Write your `viewDidLoad` as follows:

```swift
class BaseViewController: HLTabPagerViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    self.dataSource = self
    self.delegate 	= self

    self.reloadData()   
  }
}
```

Then, implement the `HLTabPagerDataSource` to populate the view.
The data source has a couple of required methods, and a few more optional.

```swift
extension BaseViewController: HLTabPagerDataSource, HLTabPagerDelegate {
    
    func numberOfViewControllers() -> Int{
        
        return dataArray.count
    }
    
    func viewController(forIndex index:Int) -> UIViewController{
        
        let contentVC = T1ViewController()
        
        contentVC.view.backgroundColor = dataArray[index].bgColor
        
        return contentVC
    }
}
```

### Data Source
The data source methods will allow you to provide content to your tab pager view controller.

#### Required Methods

```swift
func numberOfViewControllers() -> Int

func viewController(forIndex index: Int) -> UIViewController

```

#### Optional Methods
**Note that despite being optional, the tab setup will require you to return either a `UIView` or an `String` to work. Pls implement either viewForTabAtIndex: or titleForTabAtIndex: **

```swift

optional func viewForTab(atIndex index: Int) -> UIView

optional func titleForTab(atIndex index: Int) -> String

// Default value: 44.0
optional func tabHeight() -> CGFloat

// Default value: UIColor.orangeColor
optional func tabColor() -> UIColor

//UIColor(white: 0.95, alpha: 1)
optional func tabBackgroundColor() -> UIColor

//UIFont(name: "HelveticaNeue-Thin", size: 20)!
optional func titleFont() -> UIFont

// Default value: UIColor.black
optional func titleColor() -> UIColor

// Default: 2.0
optional func bottomLineHeight() -> CGFloat

```

### Delegate
The delegate methods report events that happened in the tab pager view controller.

#### Optional Methods
```swift
optional func tabPager(_ tabPager: HLTabPagerViewController, willTransitionToTab atIndex: Int)
optional func tabPager(_ tabPager: HLTabPagerViewController, didTransitionToTab atIndex: Int)
```

### Open

There are two public methods:

```swift
open func reloadData()
open func selectTabbar(atIndex index: Int, animation: Bool = false) 
```

`reloadData` will refresh the content of the tab pager view controller. Make sure to provide the data source before reloading the content.

`selectTabbar(atIndex:, animation:)`  Selects a tab in the header view identified by index

And these public properties:

```swift

open weak var dataSource: HLTabPagerDataSource?
open weak var delegate: HLTabPagerDelegate?

open var selectedIndex = 0 // will return the index of the current selected tab.

```

### License
This code is distributed under the terms and conditions of the MIT license.


