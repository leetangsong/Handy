//
//  HandyNavigationBar+UIViewController.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//

import UIKit

public enum HandyStatusBarStyle {
    case lightContent
    case `default`
    case dark
}


extension UIViewController{
    
    fileprivate struct AssociatedKeys {
        static var barStyle = "barStyle"
        static var backgroundColor = "backgroundColor"
        static var backgroundImage = "backgroundImage"
        static var tintColor = "tintColor"
        static var barAlpha = "barAlpha"
        static var titleColor = "titleColor"
        static var titleFont = "titleFont"
        static var shadowHidden = "shadowHidden"
        static var shadowColor = "shadowColor"
        static var enablePopGesture = "enablePopGesture"
        static var enableFullScreenPopGesture = "enableFullScreenPopGesture"
        static var customNaviBar = "customNaviBar"
        static var naviBarHidden = "naviBarHidden"
        static var statusBarStyle = "statusBarStyle"
        static var statusBarHidden = "statusBarHidden"
        static var isTranslucent = "isTranslucent"
    }
    
    
    func updateSystemItem(){
        if handy.customNaviBar != nil {
            var leftItems = handy.customNaviBar?.item?.leftBarButtonItems ?? []
            for item in leftItems {
                if item is HandyBarButtonItem{
                    leftItems.handy.remove(item)
                }
            }
            navigationItem.titleView = handy.customNaviBar?.item?.titleView
            navigationItem.leftBarButtonItems = leftItems
            navigationItem.rightBarButtonItems = handy.customNaviBar?.item?.rightBarButtonItems
            handy.customNaviBar = nil
        }
    }

    
}

extension UIViewController{
    
      @objc static func viewControllerSwizzling() {
        let originalMethods = [
            #selector(UIViewController.viewWillAppear(_:)),
            #selector(UIViewController.viewWillDisappear(_:)),
            #selector(UIViewController.viewDidAppear(_:)),
        ]
        let swizzledMethods = [
            #selector(UIViewController.handy_viewWillAppear(_:)),
            #selector(UIViewController.handy_viewWillDisappear(_:)),
            #selector(UIViewController.handy_viewDidAppear(_:)),
        ]

        for (i, originalMethod) in originalMethods.enumerated() {
            swizzlingForClass(UIViewController.self, originalSelector: originalMethod, swizzledSelector: swizzledMethods[i])
        }
    }
    @objc private func handy_viewWillAppear(_ animated: Bool) {
        handy_viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(handy._naviBarHidden, animated: animated)
        navigationController?.handy.navigationContext.navigationController(willShow: self, animated: animated)
        navigationController?.navigationBar.isTranslucent = handy.naviIsTranslucent
    }
    @objc private func handy_viewDidAppear(_ animated: Bool) {
        handy_viewDidAppear(animated)
        navigationController?.handy.updateNavigationBar(for: self)
    }
    @objc private func handy_viewWillDisappear(_ animated: Bool) {
        handy_viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(handy._naviBarHidden, animated: animated)
    }
}

extension UIViewController: HandyCompatible{}

extension HandyExtension where Base: UIViewController {
    
    
    
    public var statusBarStyle: HandyStatusBarStyle {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.statusBarStyle) as? HandyStatusBarStyle ?? .default
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.statusBarStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.setNeedsStatusBarAppearanceUpdate()
        }
    }
    public var statusBarHidden: Bool {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.statusBarHidden) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.statusBarHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var naviBarHidden: Bool {
        get {
            return _naviBarHidden
        }
        set {
            base.navigationController?.setNavigationBarHidden(newValue, animated: false)
            _naviBarHidden = newValue
        }
    }
    
    var _naviBarHidden: Bool {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.naviBarHidden) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.naviBarHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var naviIsTranslucent: Bool {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.isTranslucent) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.isTranslucent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarBackgroundUpdate()
        }
    }
    
    public var naviBarStyle: UIBarStyle {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.barStyle) as? UIBarStyle ?? UINavigationBar.appearance().barStyle
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.barStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarTintUpdate()
        }
    }
    
    /// 导航栏前景色（item的文字图标颜色），默认黑色
    public var naviTintColor: UIColor {
        get {
            if let tintColor = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.tintColor) as? UIColor {
                return tintColor
            }
            if let tintColor = UINavigationBar.appearance().tintColor {
                return tintColor
            }
            return .black
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.tintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarTintUpdate()
        }
    }
    
    /// 导航栏标题文字颜色，默认黑色
    public var naviTitleColor: UIColor {
        get {
            if let titleColor = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.titleColor) as? UIColor {
                return titleColor
            }
            if let titleColor = UINavigationBar.appearance().titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor {
                return titleColor
            }
            return .black
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.titleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarTintUpdate()
        }
    }
    
    /// 导航栏标题文字字体，默认17号粗体
    public var naviTitleFont: UIFont {
        get {
            if let titleFont = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.titleFont) as? UIFont {
                return titleFont
            }
            if let titleFont = UINavigationBar.appearance().titleTextAttributes?[NSAttributedString.Key.font] as? UIFont {
                return titleFont
            }
            return UIFont.boldSystemFont(ofSize: 17)
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.titleFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarTintUpdate()
        }
    }
    
    
    /// 导航栏背景色，默认白色
    public var naviBackgroundColor: UIColor {
        get {
            if let backgroundColor = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.backgroundColor) as? UIColor {
                return backgroundColor
            }
            if let backgroundColor = UINavigationBar.appearance().barTintColor {
                return backgroundColor
            }
            return .white
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.backgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarBackgroundUpdate()
        }
    }
    /// 导航栏背景图片
    public var naviBackgroundImage: UIImage? {
    
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.backgroundImage) as? UIImage ?? UINavigationBar.appearance().backgroundImage(for: .default)
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.backgroundImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarBackgroundUpdate()
        }
    }
    
    /// 导航栏背景透明度，默认1
    public var naviBarAlpha: CGFloat {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.barAlpha) as? CGFloat ?? 1
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.barAlpha, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarBackgroundUpdate()
        }
    }
   
    /// 导航栏底部分割线是否隐藏，默认不隐藏
    public var naviShadowHidden: Bool {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.shadowHidden) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.shadowHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarShadowUpdate()
        }
    }
    
    /// 导航栏底部分割线颜色
    public var naviShadowColor: UIColor {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.shadowColor) as? UIColor ?? UIColor(white: 0, alpha: 0.3)
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.shadowColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarShadowUpdate()
        }
    }
    
    /// 是否开启手势返回，默认开启
    public var isEnablePopGesture: Bool {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.enablePopGesture) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.enablePopGesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    ///是否全屏幕侧滑  优先级 enablePopGesture > enableFullScreenPopGesture
    public var isEnableFullScreenPopGesture: Bool {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.enableFullScreenPopGesture) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.enableFullScreenPopGesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var navigationItem: UINavigationItem{
        if base.navigationController?.handy.navigationStyle == .custom , let item = customNaviBar?.item{
            return item
        }
        return base.navigationItem
    }


    public var title: String?{
        set{
            base.title = newValue
            customNaviBar?.title = newValue
        }get{
            return customNaviBar?.title ?? base.title
        }
    }

    /// 自定义导航栏
    public var customNaviBar: HandyNavigationBar? {
        get {
            var bar = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.customNaviBar) as? HandyNavigationBar
            if base.navigationController?.handy.navigationStyle == .custom , bar == nil{
                bar = HandyNavigationBar()
                bar?.item?.titleView = base.navigationItem.titleView
                bar?.item?.leftBarButtonItems = base.navigationItem.leftBarButtonItems
                bar?.item?.rightBarButtonItems = base.navigationItem.rightBarButtonItems
                base.navigationItem.titleView = nil
                base.navigationItem.leftBarButtonItems = nil
                base.navigationItem.rightBarButtonItems = nil
                bar?.updateBar(for: base)
                bar?.title = base.title
                objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.customNaviBar, bar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return bar
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.customNaviBar, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: -  更新UI
    public func setNeedsNavigationBarUpdate(){
        base.navigationController?.handy.updateNavigationBar(for: base)
    }

    public func setNeedsNavigationBarTintUpdate(){
        base.navigationController?.handy.updateNavigationBarTint(for: base)
    }

    public func setNeedsNavigationBarBackgroundUpdate(){
        base.navigationController?.handy.updateNavigationBarBackground(for: base)
    }

    public func setNeedsNavigationBarShadowUpdate(){
        base.navigationController?.handy.updateNavigationBarShadow(for: base)
    }

    public func setStatusBarHidden(_ hidden: Bool , animate: Bool = false){
        base.handy.statusBarHidden = hidden
        UIView.animate(withDuration: animate ? 0.25:0) {
            self.base.setNeedsStatusBarAppearanceUpdate()
        }
    }
}


