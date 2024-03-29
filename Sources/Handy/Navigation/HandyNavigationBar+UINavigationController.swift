//
//  HandyNavigationBar+UINavigationController.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//

import UIKit
public enum HandyNavigationStyle: Int {
    ///无样式
    case none = 0
    ///系统样式
    case system
    ///类似微信效果
    case wx
    ///自定义（每个控制器单独有一个navigationBar， 视图在控制器上 注意视图层级）
    case custom

}

extension UINavigationController{
    
    fileprivate struct AssociatedKeys {
        static var barBackItem = "barBackItem"
        static var navigationStyle = "navigationStyle"
        static var useSystemBackBarButtonItem = "useSystemBackBarButtonItem"
        static var navigationContext = "navigationContext"
        static var animationBlock = "animationBlock"
        static var interactivePopGestureRecognizer = "interactivePopGestureRecognizer"
        static var fullscreenPopGestureRecognizerDelegate = "fullscreenPopGestureRecognizerDelegate"
        static var appearanceBarStyle = "appearanceBarStyle"
        static var appearanceBarBackgroundColor = "appearanceBarBackgroundColor"
        static var appearanceBarBackgroundImage = "appearanceBarBackgroundImage"
        static var appearanceBarTintColor = "appearanceBarTintColor"
        static var appearanceBarTitleColor = "appearanceBarTitleColor"
        static var appearanceBarTitleFont = "appearanceBarTitleFont"
        static var appearanceBarShadowHidden = "appearanceBarShadowHidden"
        static var appearanceBarShadowColor = "appearanceBarShadowColor"
        static var appearanceBarIsTranslucent = "appearanceBarIsTranslucent"
        static var appearanceStatusBarStyle = "appearanceStatusBarStyle"

    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle{
        return getStatusBarStyle()
    }

    open override var prefersStatusBarHidden: Bool{
        return topViewController?.handy.statusBarHidden ?? false
    }
    public func getStatusBarStyle() -> UIStatusBarStyle{
        guard let statusStyle = topViewController?.handy.statusBarStyle else {
            return .default
        }
        switch statusStyle {
        case .lightContent:
            return .lightContent
        case .default:
            return .default
        case .dark:
            if #available(iOS 13, *) {
                return .darkContent
            }
            return .default
        }
    }
}


let tsPushDuration: CGFloat = 0.2
var tsPushBeginTime: CFTimeInterval = CACurrentMediaTime()

let tsPopDuration: CGFloat = 0.15
var tsPopBeginTime: CFTimeInterval = CACurrentMediaTime()

var tsPopMiddleDuration: CGFloat = 0.1
var tsPopMiddleBeginTime: CFTimeInterval = CACurrentMediaTime()


extension UINavigationController{
   
    
    fileprivate var tsPopProgress: CGFloat{
        var progress = (CACurrentMediaTime() - tsPopBeginTime) / tsPopDuration
        progress = min(1, progress)
        return progress
    }
    
    fileprivate var tsPopMiddleProgress: CGFloat{
        var progress = (CACurrentMediaTime() - tsPopMiddleBeginTime) / tsPopMiddleDuration
        progress = min(1, progress)
        return progress
    }
    
    fileprivate var tsPushProgress: CGFloat{
        var progress = (CACurrentMediaTime() - tsPushBeginTime) / tsPushDuration
        progress = min(1, progress)
        return  progress
    }
    
    @objc private func pushNeedDisplay(){
        guard let coordinator = topViewController?.transitionCoordinator, let fromVC = coordinator.viewController(forKey: .from),
              let toVC = coordinator.viewController(forKey: .to) else {
                  return
              }
        let progress = tsPushProgress
        handy.navigationContext.updateNavigationBar(fromVC: fromVC, toVC: toVC, progress: progress)
    }
    @objc static func navigationSwizzling() {
        let originalMethods = [
            #selector(UINavigationController.pushViewController(_:animated:)),
            #selector(UINavigationController.popViewController(animated:)),
            #selector(UINavigationController.popToRootViewController(animated:)),
            #selector(UINavigationController.popToViewController(_:animated:)),
            Selector.init(("_updateInteractiveTransition:")),
            #selector(UINavigationController.setNavigationBarHidden(_:animated:)),
            #selector(UINavigationController.viewDidLayoutSubviews),
        ]
        let swizzledMethods = [
            #selector(UINavigationController.handy_pushViewController(_:animated:)),
            #selector(UINavigationController.handy_popViewController(animated:)),
            #selector(UINavigationController.handy_popToRootViewController(animated:)),
            #selector(UINavigationController.handy_popToViewController(_:animated:)),
            #selector(UINavigationController.handy_updateInteractiveTransition(_:)),
            #selector(UINavigationController.handy_setNavigationBarHidden(_:animated:)),
            #selector(UINavigationController.handy_viewDidLayoutSubviews),
        ]

        for (i, originalMethod) in originalMethods.enumerated() {
            swizzlingForClass(UINavigationController.self, originalSelector: originalMethod, swizzledSelector: swizzledMethods[i])
        }
    }
    
    @objc private func handy_viewDidLayoutSubviews() {
        handy_viewDidLayoutSubviews()
        handy.navigationContext.navigationBarUpdateFrame()
    }
    
    @objc func popNeedDisplay(){
        guard let coordinator = topViewController?.transitionCoordinator, let fromVC = coordinator.viewController(forKey: .from),
              let toVC = coordinator.viewController(forKey: .to) else {
                  return
              }
        let progress = tsPopProgress
        if coordinator.initiallyInteractive {
            return
        }
        handy.navigationContext.updateNavigationBar(fromVC: fromVC, toVC: toVC, progress: progress)
    }
    
    func needDisplayPop(){
        guard let coordinator = topViewController?.transitionCoordinator, let fromVC = coordinator.viewController(forKey: .from),
              let toVC = coordinator.viewController(forKey: .to) else {
                  return
              }
        CATransaction.begin()
        CATransaction.setAnimationDuration(tsPopMiddleDuration)
        handy.navigationContext.updateNavigationBar(fromVC: fromVC, toVC: toVC, progress: 1)
        CATransaction.commit()
    }
    @objc private func handy_updateInteractiveTransition(_ percentComplete: CGFloat){
        
        if handy.navigationStyle == .custom {
            return
        }
        guard let coordinator = transitionCoordinator,
              let fromVC = coordinator.viewController(forKey: .from),
              let toVC = coordinator.viewController(forKey: .to) else {
                  return
              }
        handy.navigationContext.updateNavigationBar(fromVC: fromVC, toVC: toVC, progress: percentComplete)
        handy_updateInteractiveTransition(percentComplete)
    }
    
    
    @objc private  func handy_setNavigationBarHidden(_ hidden: Bool, animated: Bool){
        handy_setNavigationBarHidden(hidden, animated: animated)
        guard let _ = transitionCoordinator else {
            topViewController?.handy._naviBarHidden = hidden
            return
        }
        
    }
    
    @objc private func handy_pushViewController(_ viewController: UIViewController, animated: Bool){
        
        if let gestureRecognizers = interactivePopGestureRecognizer?.view?.gestureRecognizers,
           !gestureRecognizers.contains(handy.interactivePopGestureRecognizer)
        {
            interactivePopGestureRecognizer?.view?.addGestureRecognizer(handy.interactivePopGestureRecognizer)
            
            if let internalTargets = interactivePopGestureRecognizer?.value(forKey: "targets") as? [NSObject],
               let internalTarget = internalTargets.first?.value(forKey: "target")
            {
                handy.interactivePopGestureRecognizer.addTarget(internalTarget, action: Selector(("handleNavigationTransition:")))
                handy.interactivePopGestureRecognizer.delegate = handy.popGestureRecognizerDelegate
                interactivePopGestureRecognizer?.isEnabled = false
            }
            
        }
        
        
        
        if handy.navigationStyle != .custom, handy.navigationStyle != .none {
            var displayLink: CADisplayLink? = CADisplayLink.init(target: self, selector: #selector(pushNeedDisplay))
            displayLink?.add(to: RunLoop.main, forMode: .common)
            tsPushBeginTime = CACurrentMediaTime()
            CATransaction.setCompletionBlock {
                displayLink?.invalidate()
                displayLink = nil
            }
            CATransaction.setAnimationDuration(tsPushDuration)
            CATransaction.begin()
            handy_pushViewController(viewController, animated: animated)
            CATransaction.commit()
        }else{
            handy_pushViewController(viewController, animated: animated)
        }
    }
    
    
    
    @objc private func handy_popViewController(animated: Bool) -> UIViewController? {
        var viewController: UIViewController?
        if !animated{
            topViewController?.handy.customNaviBar?.removeFromSuperview()
        }
        if handy.navigationStyle != .custom, handy.navigationStyle != .none {
            var displayLink: CADisplayLink? = CADisplayLink.init(target: self, selector: #selector(popNeedDisplay))
            displayLink?.add(to: RunLoop.main, forMode: .common)
            tsPopBeginTime = CACurrentMediaTime()
            CATransaction.setCompletionBlock {
                displayLink?.invalidate()
                displayLink = nil
            }
            CATransaction.setAnimationDuration(tsPushDuration)
            CATransaction.begin()
            viewController = handy_popViewController(animated: animated)
            CATransaction.commit()
        }else{
            viewController = handy_popViewController(animated: animated)
        }
        return viewController
    }
    
    @objc private func handy_popToRootViewController(animated: Bool) -> [UIViewController]? {
        var vcArray: [UIViewController]?
        if !animated{
            topViewController?.handy.customNaviBar?.removeFromSuperview()
        }
        if handy.navigationStyle != .custom, handy.navigationStyle != .none {
            var displayLink: CADisplayLink? = CADisplayLink.init(target: self, selector: #selector(popNeedDisplay))
            displayLink?.add(to: RunLoop.main, forMode: .common)
            tsPopBeginTime = CACurrentMediaTime()
            CATransaction.setCompletionBlock {
                displayLink?.invalidate()
                displayLink = nil
            }
            CATransaction.setAnimationDuration(tsPushDuration)
            CATransaction.begin()
            vcArray = handy_popToRootViewController(animated: animated)
            CATransaction.commit()
        }else{
            vcArray = handy_popToRootViewController(animated: animated)
        }
        return vcArray
    }
    
    @objc private func handy_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        var vcArray: [UIViewController]?
        if !animated{
            topViewController?.handy.customNaviBar?.removeFromSuperview()
        }
        if handy.navigationStyle != .custom, handy.navigationStyle != .none {
            var displayLink: CADisplayLink? = CADisplayLink.init(target: self, selector: #selector(popNeedDisplay))
            displayLink?.add(to: RunLoop.main, forMode: .common)
            tsPopBeginTime = CACurrentMediaTime()
            CATransaction.setCompletionBlock {
                displayLink?.invalidate()
                displayLink = nil
            }
            CATransaction.setAnimationDuration(tsPushDuration)
            CATransaction.begin()
            vcArray = handy_popToViewController(viewController, animated: animated)
            CATransaction.commit()
        }else{
            vcArray = handy_popToViewController(viewController, animated: animated)
        }
        return vcArray
    }
}


public extension HandyExtension where Base: UINavigationController{
    
    var appearanceBarIsTranslucent: Bool? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarIsTranslucent) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarIsTranslucent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.topViewController?.handy.setNeedsNavigationBarBackgroundUpdate()
        }
    }
    
    var appearanceBarStyle: UIBarStyle? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarStyle) as? UIBarStyle ?? .default
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.topViewController?.handy.setNeedsNavigationBarTintUpdate()
        }
        
    }
    
    var appearanceStatusBarStyle: HandyStatusBarStyle? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceStatusBarStyle) as? HandyStatusBarStyle
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceStatusBarStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.topViewController?.setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    
    /// 导航栏前景色（item的文字图标颜色），默认黑色
    var appearanceBarTintColor: UIColor? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarTintColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.topViewController?.handy.setNeedsNavigationBarTintUpdate()
        }
    }
    
    /// 导航栏标题文字颜色，默认黑色
    var appearanceBarTitleColor: UIColor? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarTitleColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarTitleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.topViewController?.handy.setNeedsNavigationBarTintUpdate()
        }
    }
    
    /// 导航栏标题文字字体，默认17号粗体
    var appearanceBarTitleFont: UIFont? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarTitleFont) as? UIFont
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarTitleFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.topViewController?.handy.setNeedsNavigationBarTintUpdate()
        }
    }
    
    
    /// 导航栏背景色
    var appearanceBarBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarBackgroundColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarBackgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.topViewController?.handy.setNeedsNavigationBarBackgroundUpdate()
        }
    }
    /// 导航栏背景图片
    var appearanceBarBackgroundImage: UIImage? {
    
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarBackgroundImage) as? UIImage
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarBackgroundImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.topViewController?.handy.setNeedsNavigationBarBackgroundUpdate()
        }
    }
   
    /// 导航栏底部分割线是否隐藏，默认不隐藏
    var appearanceBarShadowHidden: Bool? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarShadowHidden) as? Bool
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarShadowHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.topViewController?.handy.setNeedsNavigationBarShadowUpdate()
        }
    }
    
    /// 导航栏底部分割线颜色
    var appearanceBarShadowColor: UIColor? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarShadowColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.appearanceBarShadowColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.topViewController?.handy.setNeedsNavigationBarShadowUpdate()
        }
    }
    
    
    
    ///若设置 则替代系统默认的返回
    var barBackItem: UIBarButtonItem? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.barBackItem) as? UIBarButtonItem
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.barBackItem, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var useSystemBackBarButtonItem: Bool {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.useSystemBackBarButtonItem) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.useSystemBackBarButtonItem, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var interactivePopGestureRecognizer: UIPanGestureRecognizer {
        var pan = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.interactivePopGestureRecognizer) as? UIPanGestureRecognizer
        if pan == nil{
            pan = UIPanGestureRecognizer()
            pan?.maximumNumberOfTouches = 1
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.interactivePopGestureRecognizer, pan!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return pan!
    }
    
    fileprivate var popGestureRecognizerDelegate: HandyFullscreenPopGestureRecognizerDelegate {
        var delegate = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.fullscreenPopGestureRecognizerDelegate) as? HandyFullscreenPopGestureRecognizerDelegate
        if delegate == nil{
            delegate = HandyFullscreenPopGestureRecognizerDelegate()
            delegate?.navigationController = base
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.fullscreenPopGestureRecognizerDelegate, delegate!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return delegate!
    }
    
    
    var navigationStyle: HandyNavigationStyle {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.navigationStyle) as? HandyNavigationStyle ?? .none
        }
        set {
            
            let _oldValue = base.handy.navigationStyle
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.navigationStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let topVC = base.topViewController else {
                return
            }
            if _oldValue != newValue {
                if _oldValue == .custom {
                    navigationContext.fakeBar.removeFromSuperview()
                    navigationContext.fromFakeBar.removeFromSuperview()
                    navigationContext.toFakeBar.removeFromSuperview()

                    navigationContext.fakeBar = FakeNavigationBar()
                    navigationContext.fromFakeBar = FakeNavigationBar()
                    navigationContext.toFakeBar = FakeNavigationBar()
                }
                if navigationStyle == .custom{
                    navigationContext.systemContentViewShow(flag: false)

                    topVC.handy.navigationItem.titleView = topVC.handy.navigationItem.titleView ?? topVC.navigationItem.titleView
                    topVC.handy.navigationItem.leftBarButtonItems = topVC.handy.navigationItem.leftBarButtonItems ?? topVC.navigationItem.leftBarButtonItems
                    topVC.handy.navigationItem.rightBarButtonItems = topVC.handy.navigationItem.rightBarButtonItems ?? topVC.navigationItem.rightBarButtonItems
                    topVC.navigationItem.titleView = nil
                    topVC.navigationItem.leftBarButtonItems = nil
                    topVC.navigationItem.rightBarButtonItems = nil
                    base.view.setNeedsLayout()
                }else{
                    navigationContext.systemContentViewShow(flag: true)
                    if _oldValue == .custom {
                        for vc in base.viewControllers{
                            vc.updateSystemItem()
                        }
                    }
                }
                
                topVC.handy.title = topVC.handy.title
                if newValue == .none{
                    base.navigationBar.subviews.first?.isUserInteractionEnabled = true
                    navigationContext.fakeBar.removeFromSuperview()
                    navigationContext.fromFakeBar.removeFromSuperview()
                    navigationContext.toFakeBar.removeFromSuperview()
                    navigationContext.alphaObserver?.invalidate()
                    navigationContext.naviFrameObserver?.invalidate()
                    navigationContext.naviFrameObserver = nil
                    navigationContext.alphaObserver = nil
                    for subView in base.navigationBar.subviews.first?.subviews ?? [] {
                        subView.alpha = 1
                    }
                    base.view.layoutIfNeeded()
                    updateNavigationBar(for: topVC)
                }else{
                    navigationContext.clearTempFakeBar()
                    updateNavigationBar(for: topVC)
                }
                navigationContext.installsLeftBarButtonItemIfNeeded(for: topVC)
            }
            
        }
    }
    var navigationBar: UINavigationBar{
        guard let topVC = base.topViewController else {
            return base.navigationBar
        }
        return navigationStyle == .custom ? (topVC.handy.customNaviBar ?? base.navigationBar) : base.navigationBar
    }
    
    var animationBlock: ((_ finished: Bool)->Void)? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.animationBlock) as? (_ finished: Bool)->Void
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.animationBlock, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var navigationContext: HandyNavigationContrllerContext{
        get {
            if let context = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.navigationContext) as? HandyNavigationContrllerContext{
                return context
            }
            let context = HandyNavigationContrllerContext(navigationController: base)
            self.navigationContext = context
            return context
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.navigationContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal func updateNavigationBar(for viewController: UIViewController) {
        if navigationStyle == .none{
            return
        }
        updateNavigationBarTint(for: viewController)
        updateNavigationBarBackground(for: viewController)
        updateNavigationBarShadow(for: viewController)
        
    }
    
    internal func updateNavigationBarTint(for viewController: UIViewController) {
        if viewController != base.topViewController{
            return
        }
        let navigationBar = navigationBar
        var titleTextAttributes = navigationBar.titleTextAttributes ?? [:]
        titleTextAttributes[.foregroundColor] = viewController.handy.naviTitleColor
        titleTextAttributes[.font] = viewController.handy.naviTitleFont
        base.navigationBar.barStyle = viewController.handy.naviBarStyle
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.tintColor = viewController.handy.naviTintColor
    }
    
    
    internal func updateNavigationBarBackground(for viewController: UIViewController) {
        if viewController != base.topViewController{
            return
        }
        var bar: HandyNavigationBar?
        if navigationStyle == .none{
            var color: UIColor? = viewController.handy.naviBackgroundColor
            if color == .clear{
                color = nil
            }
            base.navigationBar.barTintColor = color
            base.navigationBar.setBackgroundImage(viewController.handy.naviBackgroundImage, for: .default)
            base.navigationBar.handy.backgroundAlpha = viewController.handy.naviBarAlpha
        }else if navigationStyle == .custom {
            bar = viewController.handy.customNaviBar
            base.navigationBar.isTranslucent = viewController.handy.naviIsTranslucent
        }else{
            bar = navigationContext.fakeBar
            base.navigationBar.isTranslucent = viewController.handy.naviIsTranslucent
        }
        bar?.updateBarBackground(for: viewController)
        
    }
    
    internal func updateNavigationBarShadow(for viewController: UIViewController) {
        if viewController != base.topViewController{
            return
        }
        var bar: HandyNavigationBar?
        
        if navigationStyle == .none{
            base.navigationBar.shadowImage = viewController.handy.naviShadowHidden ? UIImage(): UIImage.handy.image(for: viewController.handy.naviShadowColor)
        }else if navigationStyle == .custom {
            bar = viewController.handy.customNaviBar
        }else{
            bar = navigationContext.fakeBar
        }
        bar?.updateBarShadow(for: viewController)
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool,  complete: ((_ finished: Bool)->Void)? = nil){
        complete?(false)
        animationBlock = complete
        base.pushViewController(viewController, animated: animated)
    }
    
    func removeViewController(_ viewController: UIViewController, animated: Bool = false){
        var controllers = base.viewControllers
        var controllerToRemove: UIViewController?
        for obj in controllers {
            if obj == viewController {
                controllerToRemove = viewController
                break
            }
        }
        if let controllerToRemove = controllerToRemove {
            controllers.handy.remove(controllerToRemove)
            base.setViewControllers(controllers, animated: animated)
        }
    }
    
}


class HandyFullscreenPopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate{
    weak var navigationController: UINavigationController?
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (navigationController?.viewControllers.count ?? 0) <= 1{
            return false
        }
        guard let topViewController = navigationController?.viewControllers.last else { return false }
        if  !topViewController.handy.isEnablePopGesture {
            return false
        }
        guard let view = gestureRecognizer.view else { return false}
        
        let locationX = gestureRecognizer.location(in: view).x
        if locationX>=80 && !topViewController.handy.isEnableFullScreenPopGesture{
            return false
        }
        if let  isTransitioning = navigationController?.value(forKey: "_isTransitioning") as? Bool, isTransitioning{
            return false
        }
        
        let translation = (gestureRecognizer as? UIPanGestureRecognizer)?.translation(in: view) ?? .zero
        let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
        let multiplier: CGFloat = isLeftToRight ? 1 : -1
        if (translation.x * multiplier) <= 0{
            return false
        }
        
        return true
    }
    
}
