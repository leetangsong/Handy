//
//  UIWindow+Theme.swift
//  Handy
//
//  Created by leetangsong on 2022/11/4.
//

import Foundation

extension UIWindow{
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if !self.isMember(of: UIWindow.self){
            return
        }
//        if #available(iOS 13.0, *){
//            if !ThemeManager.isFollowSystemTheme{ return }
//            let state = UIApplication.shared.applicationState
//            if state == .background{
//                ThemeManager.systemThemeChange(previousTraitCollection?.userInterfaceStyle)
//            }else{
//                if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection){
//                    ThemeManager.systemThemeChange(previousTraitCollection?.userInterfaceStyle)
//                }
//            }
//        }
    }
    
}
