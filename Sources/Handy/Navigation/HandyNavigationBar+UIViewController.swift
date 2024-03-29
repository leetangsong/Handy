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
        static var navigationController = "navigationController"
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
        guard navigationController?.topViewController == self else { return }
        navigationController?.setNavigationBarHidden(handy._naviBarHidden, animated: animated)
        navigationController?.handy.navigationContext.navigationController(willShow: self, animated: animated)
        navigationController?.navigationBar.isTranslucent = handy.naviIsTranslucent
    }
    @objc private func handy_viewDidAppear(_ animated: Bool) {
        handy_viewDidAppear(animated)
        guard navigationController?.topViewController == self else { return }
        navigationController?.handy.updateNavigationBar(for: self)
    }
    @objc private func handy_viewWillDisappear(_ animated: Bool) {
        handy_viewWillDisappear(animated)
        //需要判断 是否属于 viewController 的 children
        if let navi = navigationController,
           !navi.viewControllers.contains(self), let parent = parent, !parent.isKind(of: UINavigationController.self){
            return
        }
        navigationController?.setNavigationBarHidden(handy._naviBarHidden, animated: animated)
    }
}

extension UIViewController: HandyCompatible{}

public extension HandyExtension where Base: UIViewController {
    
    var statusBarStyle: HandyStatusBarStyle {
        get {
            
            if let style = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.statusBarStyle) as? HandyStatusBarStyle{
                return style
            }
            if let style = navigationController?.handy.appearanceStatusBarStyle{
                return style
            }
            return .default
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.statusBarStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.setNeedsStatusBarAppearanceUpdate()
        }
    }
    var statusBarHidden: Bool {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.statusBarHidden) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.statusBarHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var naviBarHidden: Bool {
        get {
            return _naviBarHidden
        }
        set {
            base.navigationController?.setNavigationBarHidden(newValue, animated: false)
            _naviBarHidden = newValue
        }
    }
    
    internal var _naviBarHidden: Bool {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.naviBarHidden) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.naviBarHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var naviIsTranslucent: Bool {
        get {
            
            if let isTranslucent = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.isTranslucent) as? Bool {
                return isTranslucent
            }
            if let isTranslucent = navigationController?.handy.appearanceBarIsTranslucent{
                return isTranslucent
            }
            return true
            
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.isTranslucent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarBackgroundUpdate()
        }
    }
    
    var naviBarStyle: UIBarStyle {
        get {
            
            if let barStyle = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.barStyle) as? UIBarStyle {
                return barStyle
            }
            if let barStyle = navigationController?.handy.appearanceBarStyle{
                return barStyle
            }
            return .default
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.barStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarTintUpdate()
        }
    }
    
    /// 导航栏前景色（item的文字图标颜色），默认黑色
    var naviTintColor: UIColor {
        get {
            if let tintColor = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.tintColor) as? UIColor {
                return tintColor
            }
            
            if let tintColor = navigationController?.handy.appearanceBarTintColor{
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
    var naviTitleColor: UIColor {
        get {
            if let titleColor = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.titleColor) as? UIColor {
                return titleColor
            }
            
            if let titleColor = navigationController?.handy.appearanceBarTitleColor{
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
    var naviTitleFont: UIFont {
        get {
            if let titleFont = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.titleFont) as? UIFont {
                return titleFont
            }
            
            if let titleFont = navigationController?.handy.appearanceBarTitleFont{
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
    
    
    /// 导航栏背景色
    var naviBackgroundColor: UIColor {
        get {
            if let backgroundColor = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.backgroundColor) as? UIColor {
                return backgroundColor
            }
            
            if let backgroundColor = navigationController?.handy.appearanceBarBackgroundColor{
                return backgroundColor
            }
            
            if let backgroundColor = UINavigationBar.appearance().barTintColor {
                return backgroundColor
            }
            return .clear
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.backgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarBackgroundUpdate()
        }
    }
    /// 导航栏背景图片
    var naviBackgroundImage: UIImage? {
    
        get {
            
            if let backgroundImage = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.backgroundImage) as? UIImage {
                return backgroundImage
            }
            
            if let backgroundImage = navigationController?.handy.appearanceBarBackgroundImage{
                return backgroundImage
            }
            
            if let backgroundImage = UINavigationBar.appearance().backgroundImage(for: .default) {
                return backgroundImage
            }
            return nil
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.backgroundImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarBackgroundUpdate()
        }
    }
   
    /// 导航栏底部分割线是否隐藏，默认不隐藏
    var naviShadowHidden: Bool {
        get {
            if let shadowHidden = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.shadowHidden) as? Bool {
                return shadowHidden
            }
            
            if let shadowHidden = navigationController?.handy.appearanceBarShadowHidden{
                return shadowHidden
            }
            return false
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.shadowHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarShadowUpdate()
        }
    }
    
    /// 导航栏底部分割线颜色
    var naviShadowColor: UIColor {
        get {
            if let shadowColor = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.shadowColor) as? UIColor {
                return shadowColor
            }
            
            if let shadowColor = navigationController?.handy.appearanceBarShadowColor{
                return shadowColor
            }
            return UIColor(white: 0, alpha: 0.3)
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.shadowColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarShadowUpdate()
        }
    }
    
    /// 导航栏背景透明度，默认1
    var naviBarAlpha: CGFloat {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.barAlpha) as? CGFloat ?? 1
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.barAlpha, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarBackgroundUpdate()
        }
    }
    
    /// 是否开启手势返回，默认开启
    var isEnablePopGesture: Bool {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.enablePopGesture) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.enablePopGesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    ///是否全屏幕侧滑  优先级 enablePopGesture > enableFullScreenPopGesture
    var isEnableFullScreenPopGesture: Bool {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.enableFullScreenPopGesture) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.enableFullScreenPopGesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var navigationItem: UINavigationItem{
        if base.navigationController?.handy.navigationStyle == .custom , let item = customNaviBar?.item{
            return item
        }
        return base.navigationItem
    }


    var title: String?{
        set{
            base.title = newValue
            customNaviBar?.title = newValue
        }get{
            return customNaviBar?.title ?? base.title
        }
    }

    /// 自定义导航栏
    var customNaviBar: HandyNavigationBar? {
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
    internal var navigationController: UINavigationController? {
        get {
            return base.getWeakHost(HandyNavigationWeakHost.self)?.navigationController ?? base.navigationController
        }
        set {
            base.getWeakHost(HandyNavigationWeakHost.self)?.navigationController = newValue
        }
    }
   
    // MARK: -  更新UI
    func setNeedsNavigationBarUpdate(){
        base.navigationController?.handy.updateNavigationBar(for: base)
    }

    func setNeedsNavigationBarTintUpdate(){
        base.navigationController?.handy.updateNavigationBarTint(for: base)
    }

    func setNeedsNavigationBarBackgroundUpdate(){
        base.navigationController?.handy.updateNavigationBarBackground(for: base)
    }

    func setNeedsNavigationBarShadowUpdate(){
        base.navigationController?.handy.updateNavigationBarShadow(for: base)
    }

    func setStatusBarHidden(_ hidden: Bool , animate: Bool = false){
        base.handy.statusBarHidden = hidden
        UIView.animate(withDuration: animate ? 0.25:0) {
            self.base.setNeedsStatusBarAppearanceUpdate()
        }
    }
}


