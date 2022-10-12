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
    case system = 1
    ///类似微信效果
    case wx = 2
    ///自定义（每个控制器单独有一个navigationBar）
    case custom = 3
    
}

extension UINavigationController{
    
    fileprivate struct AssociatedKeys {
        static var barBackItem = "barBackItem"
        static var navigationStyle = "navigationStyle"
        static var useSystemBackBarButtonItem = "useSystemBackBarButtonItem"
        static var navigationContext = "navigationContext"
        static var animationBlock = "animationBlock"
        static var interactivePopGestureRecognizer = "interactivePopGestureRecognizer"
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
    public override class func swizzling() {
        super.swizzling()
        let originalMethods = [
            #selector(UINavigationController.pushViewController(_:animated:)),
            #selector(UINavigationController.popViewController(animated:)),
            #selector(UINavigationController.popToRootViewController(animated:)),
            #selector(UINavigationController.popToViewController(_:animated:)),
            Selector.init(("_updateInteractiveTransition:")),
            #selector(UINavigationController.setNavigationBarHidden(_:animated:)),
        ]
        let swizzledMethods = [
            #selector(UINavigationController.handy_pushViewController(_:animated:)),
            #selector(UINavigationController.handy_popViewController(animated:)),
            #selector(UINavigationController.handy_popToRootViewController(animated:)),
            #selector(UINavigationController.handy_popToViewController(_:animated:)),
            #selector(UINavigationController.handy_updateInteractiveTransition(_:)),
            #selector(UINavigationController.handy_setNavigationBarHidden(_:animated:))
        ]

        for (i, originalMethod) in originalMethods.enumerated() {
            swizzlingForClass(UINavigationController.self, originalSelector: originalMethod, swizzledSelector: swizzledMethods[i])
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if let target = interactivePopGestureRecognizer?.delegate{
            handy.interactivePopGestureRecognizer = UIPanGestureRecognizer.init(target: target, action: Selector(("handleNavigationTransition:")))
            handy.interactivePopGestureRecognizer?.delegate = self
            view.addGestureRecognizer(handy.interactivePopGestureRecognizer!)
            interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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


extension UINavigationController: UIGestureRecognizerDelegate{
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer, pan == handy.interactivePopGestureRecognizer else { return true }
        if children.count == 1{
            return false
        }
        
        let locationX = pan.location(in: nil).x
        
        if locationX>=80 && topViewController?.handy.isEnableFullScreenPopGesture == false{
            return false
        }
        
        if let topViewController = topViewController {
            return topViewController.handy.isEnablePopGesture
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UISlider{
            return false
        }
        return true
    }
}


extension HandyExtension where Base: UINavigationController{
    ///若设置 则替代系统默认的返回
    public var barBackItem: UIBarButtonItem? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.barBackItem) as? UIBarButtonItem
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.barBackItem, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var useSystemBackBarButtonItem: Bool {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.useSystemBackBarButtonItem) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.useSystemBackBarButtonItem, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var interactivePopGestureRecognizer: UIPanGestureRecognizer? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.interactivePopGestureRecognizer) as? UIPanGestureRecognizer
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.interactivePopGestureRecognizer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var navigationStyle: HandyNavigationStyle {
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
    public var navigationBar: UINavigationBar{
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
    
    var navigationContext: HandyNavigationContrllerContext{
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
    
    func updateNavigationBar(for viewController: UIViewController) {
        updateNavigationBarTint(for: viewController)
        updateNavigationBarBackground(for: viewController)
        updateNavigationBarShadow(for: viewController)
        
    }
    
    func updateNavigationBarTint(for viewController: UIViewController) {
        
        let navigationBar = navigationBar
        var titleTextAttributes = navigationBar.titleTextAttributes ?? [:]
        titleTextAttributes[.foregroundColor] = viewController.handy.naviTitleColor
        titleTextAttributes[.font] = viewController.handy.naviTitleFont
        base.navigationBar.barStyle = viewController.handy.naviBarStyle
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.tintColor = viewController.handy.naviTintColor
    }
    
    
    func updateNavigationBarBackground(for viewController: UIViewController) {
        
        var bar: HandyNavigationBar?
        if navigationStyle == .none{
            base.navigationBar.barTintColor = viewController.handy.naviBackgroundColor
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
    
    func updateNavigationBarShadow(for viewController: UIViewController) {
        
        var bar: HandyNavigationBar?
        
        if navigationStyle == .none{
            base.navigationBar.shadowImage = viewController.handy.naviShadowHidden ? UIImage(): UIImage.handy.image(with: viewController.handy.naviShadowColor)
        }else if navigationStyle == .custom {
            bar = viewController.handy.customNaviBar
        }else{
            bar = navigationContext.fakeBar
        }
        bar?.updateBarShadow(for: viewController)
    }
    
    public func pushViewController(_ viewController: UIViewController, animated: Bool,  complete: ((_ finished: Bool)->Void)? = nil){
        complete?(false)
        animationBlock = complete
        base.pushViewController(viewController, animated: animated)
    }
    
    public func removeViewController(_ viewController: UIViewController, animated: Bool = false){
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


