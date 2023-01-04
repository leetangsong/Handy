//
//  UIWindow+Theme.swift
//  Handy
//
//  Created by leetangsong on 2022/10/27.
//

import UIKit

extension UIViewController{
    
    @objc static func viewControllerThemeSwizzling() {
        let originalMethods = [
            #selector(UIViewController.traitCollectionDidChange(_:))
        ]
        let swizzledMethods = [
            #selector(UIViewController.handy_traitCollectionDidChange(_:))
        ]
        for (i, originalMethod) in originalMethods.enumerated() {
            swizzlingForClass(UIViewController.self, originalSelector: originalMethod, swizzledSelector: swizzledMethods[i])
        }
    }
    @objc private func handy_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        handy_traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *){
            if !ThemeManager.isFollowSystemTheme{ return }
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection){
                ThemeManager.systemThemeChange()
            }
        }
        
    }
}
