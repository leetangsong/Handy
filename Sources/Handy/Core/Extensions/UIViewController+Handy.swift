//
//  UIViewController+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//

import UIKit



public extension HandyClassExtension where Base: UIViewController{
    class func current(baseVC: UIViewController? = UIApplication.shared.currentWindow?.rootViewController) -> UIViewController?{
        if let nav = baseVC as? UINavigationController{
            return current(baseVC: nav.visibleViewController)
        }
        if let tab = baseVC as? UITabBarController{
            return current(baseVC:  tab.selectedViewController)
        }
        
        if let presented = baseVC?.presentedViewController{
            return current(baseVC: presented)
        }
        
        if let split = baseVC as? UISplitViewController{
            return current(baseVC: split.presentingViewController)
        }
        return baseVC
    }
    
}

