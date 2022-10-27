//
//  NSObject+Theme.swift
//  SwiftTheme
//
//  Created by Gesen on 16/1/22.
//  Copyright © 2016年 Gesen. All rights reserved.
//

import UIKit

fileprivate typealias setCGColorValueIMP        = @convention(c) (NSObject, Selector, CGColor) -> Void
fileprivate typealias setCGFloatValueIMP        = @convention(c) (NSObject, Selector, CGFloat) -> Void
fileprivate typealias setValueForStateIMP       = @convention(c) (NSObject, Selector, AnyObject, UIControl.State) -> Void
fileprivate typealias setKeyboardValueIMP       = @convention(c) (NSObject, Selector, UIKeyboardAppearance) -> Void
fileprivate typealias setActivityStyleValueIMP  = @convention(c) (NSObject, Selector, UIActivityIndicatorView.Style) -> Void
fileprivate typealias setScrollStyleValueIMP    = @convention(c) (NSObject, Selector, UIScrollView.IndicatorStyle) -> Void
#if os(iOS)
fileprivate typealias setBarStyleValueIMP       = @convention(c) (NSObject, Selector, UIBarStyle) -> Void
fileprivate typealias setStatusBarStyleValueIMP = @convention(c) (NSObject, Selector, UIStatusBarStyle, Bool) -> Void
#endif

extension NSObject{
    fileprivate struct AssociatedKeys {
        static var themePickers = "themePickers"
        static var hasAddPickerNotification = "hasAddPickerNotification"
    }
}


extension NSObject: ThemeCompatible{}

extension ThemeExtension where Base: NSObject{
    typealias ThemePickers = [String: ThemePicker]
    
    var themePickers: ThemePickers {
        get {
            if let themePickers = objc_getAssociatedObject(base, &NSObject.AssociatedKeys.themePickers) as? ThemePickers {
                return themePickers
            }
            let initValue = ThemePickers()
            objc_setAssociatedObject(base, &NSObject.AssociatedKeys.themePickers, initValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return initValue
        }
        set {
            objc_setAssociatedObject(base, &NSObject.AssociatedKeys.themePickers, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue.isEmpty == false { base._setupThemeNotification() }
            
        }
    }
    
    var hasAddPickerNotification: Bool {
        get {
            return objc_getAssociatedObject(base, &NSObject.AssociatedKeys.hasAddPickerNotification) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(base, &NSObject.AssociatedKeys.hasAddPickerNotification, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    
    
    
}


extension NSObject {
    
    fileprivate func _setupThemeNotification() {
        
        if theme.hasAddPickerNotification == false {
            theme.hasAddPickerNotification = true
            NotificationCenter.default.addObserver(self, selector: #selector(_updateTheme), name: NSNotification.Name(rawValue: ThemeUpdateNotification), object: nil)
        }
        
    }
    
    @objc private func _updateTheme() {
        theme.themePickers.forEach { selector, picker in
            
            UIView.animate(withDuration: ThemeManager.animationDuration) {
                self.performThemePicker(selector: selector, picker: picker)
                // For iOS 13, force an update of the nav bar when the theme changes.
                if #available(iOS 13.0, *) {
                    if let navBar = self as? UINavigationBar {
                        navBar.setNeedsLayout()
                    }
                }
                if let vc = UIViewController.handy.current(){
                    vc.handy.setNeedsNavigationBarUpdate()
                }
            }
        }
    }
    
    func performThemePicker(selector: String, picker: ThemePicker?) {
        
        if let vc = self as? UIViewController, let value = picker?.value() {
            if let _ = picker as? ThemeStatusBarStylePicker{
                let style = value as! UIStatusBarStyle
                vc.handy.statusBarStyle = ThemeStatusBarStylePicker.getHandyStyle(style: style)
            }
            
            if let _ = picker as? ThemeBarStylePicker{
                let style = value as! UIBarStyle
                vc.handy.naviBarStyle = style
            }
            if let _ = picker as? ThemeColorPicker{
                let color = value as! UIColor
                if selector == "naviTintColor"{
                    vc.handy.naviTintColor = color
                }else if selector == "naviTitleColor"{
                    vc.handy.naviTitleColor = color
                }else if selector == "naviBackgroundColor"{
                    vc.handy.naviBackgroundColor = color
                }else if selector == "naviShadowColor"{
                    vc.handy.naviShadowColor = color
                }
            }else if let _ = picker as? ThemeFontPicker{
                let font = value as! UIFont
                if selector == "naviTitleFont"{
                    vc.handy.naviTitleFont = font
                }
            }else if let _ = picker as? ThemeImagePicker{
                let image = value as? UIImage
                if selector == "naviTitleFont"{
                    vc.handy.naviBackgroundImage = image
                }
            }
            
            return
        }
        let sel = Selector(selector)
        guard let value = picker?.value() else { return }
        guard responds(to: sel) else {
            let clsString = NSStringFromClass(type(of: self))
            if clsString == "_UIAppearance" {
                if self.description.contains("UINavigationBar"){
                    setNavigationAppearance(selector: selector, value: value)
                }else if clsString.contains("UITabBar"){
                    setTabBarAppearance(selector: selector, value: value)
                }else if clsString.contains("UIToolBar"){
                    setToolBarAppearance(selector: selector, value: value)
                }
            }
            return
        }
        if let statePicker = picker as? ThemeStatePicker {
            let setState = unsafeBitCast(method(for: sel), to: setValueForStateIMP.self)
            statePicker.values.forEach {
                guard let value = $1.value() else {
                    print("SwiftTheme WARNING: Missing value for ThemeStatePicker! Selector: \(String(describing: sel))")
                    return
                }
                setState(self, sel, value as AnyObject, UIControl.State(rawValue: $0))
            }
        }
        
        else if let statusBarStylePicker = picker as? ThemeStatusBarStylePicker {
#if os(iOS)
            let setStatusBarStyle = unsafeBitCast(method(for: sel), to: setStatusBarStyleValueIMP.self)
            setStatusBarStyle(self, sel, value as! UIStatusBarStyle, statusBarStylePicker.animated)
#endif
        }
        
        else if picker is ThemeBarStylePicker {
#if os(iOS)
            let setBarStyle = unsafeBitCast(method(for: sel), to: setBarStyleValueIMP.self)
            setBarStyle(self, sel, value as! UIBarStyle)
#endif
        }
        
        else if picker is ThemeKeyboardAppearancePicker {
            let setKeyboard = unsafeBitCast(method(for: sel), to: setKeyboardValueIMP.self)
            setKeyboard(self, sel, value as! UIKeyboardAppearance)
        }
        
        else if picker is ThemeActivityIndicatorViewStylePicker {
            let setActivityStyle = unsafeBitCast(method(for: sel), to: setActivityStyleValueIMP.self)
            setActivityStyle(self, sel, value as! UIActivityIndicatorView.Style)
        }
        
        else if picker is ThemeScrollViewIndicatorStylePicker {
            let setIndicatorStyle = unsafeBitCast(method(for: sel), to: setScrollStyleValueIMP.self)
            setIndicatorStyle(self, sel, value as! UIScrollView.IndicatorStyle)
        }
        
        else if picker is ThemeCGFloatPicker {
            let setCGFloat = unsafeBitCast(method(for: sel), to: setCGFloatValueIMP.self)
            setCGFloat(self, sel, value as! CGFloat)
        }
        
        else if picker is ThemeCGColorPicker {
            let setCGColor = unsafeBitCast(method(for: sel), to: setCGColorValueIMP.self)
            setCGColor(self, sel, value as! CGColor)
        }
        
        else { perform(sel, with: value) }
    }
    func setNavigationAppearance(selector: String, value: Any) {
        let obj = UINavigationBar.appearance()
        if selector == "setBarTintColor:"{
            obj.barTintColor = value as? UIColor
        }else if selector == "setTintColor:"{
            obj.tintColor = value as? UIColor
        }else if selector == "setBarStyle:"{
            obj.barStyle = value as! UIBarStyle
        }else if selector == "setTitleTextAttributes:"{
            obj.titleTextAttributes = value as? [NSAttributedString.Key : Any]
        }else if selector == "setLargeTitleTextAttributes:"{
            obj.largeTitleTextAttributes = value as? [NSAttributedString.Key : Any]
        }else if selector == "setStandardAppearance:"{
            if #available(iOS 13.0, *) {
                obj.standardAppearance = value as! UINavigationBarAppearance
            }
        }else if selector == "setCompactAppearance:"{
            if #available(iOS 13.0, *) {
                obj.compactAppearance = value as? UINavigationBarAppearance
            }
        }else if selector == "setScrollEdgeAppearance:"{
            if #available(iOS 13.0, *) {
                obj.scrollEdgeAppearance = value as? UINavigationBarAppearance
            }
        }
    }
    
    func setTabBarAppearance(selector: String, value: Any) {
        let obj = UITabBar.appearance()
        if selector == "setBarTintColor:"{
            obj.barTintColor = value as? UIColor
        }else if selector == "setBarStyle:"{
            obj.barStyle = value as! UIBarStyle
        }else if selector == "setTintColor:"{
            obj.tintColor = value as? UIColor
        }else if selector == "setUnselectedItemTintColor:"{
            obj.unselectedItemTintColor = value as? UIColor
        }else if selector == "setStandardAppearance:"{
            if #available(iOS 13.0, *) {
                obj.standardAppearance = value as! UITabBarAppearance
            }
        }else if selector == "setScrollEdgeAppearance:"{
            if #available(iOS 15.0, *) {
                obj.scrollEdgeAppearance = value as? UITabBarAppearance
            }
        }
    }
    
    func setToolBarAppearance(selector: String, value: Any) {
        let obj = UIToolbar.appearance()
        if selector == "setBarTintColor:"{
            obj.barTintColor = value as? UIColor
        }else if selector == "setTintColor:"{
            obj.tintColor = value as? UIColor
        }else if selector == "setBarStyle:"{
            obj.barStyle = value as! UIBarStyle
        }
    }
}


