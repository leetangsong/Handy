//
//  HandyNavigationContrllerContext.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//

import UIKit


class HandyTransitionContainerView: UIView{}

@objc public protocol HandyNavigationItemCustomizable{
    @objc optional func handy_customBackItem(_ target: Any?, action: Selector) -> UIBarButtonItem
}

class HandyNavigationContrllerContext: NSObject {
    
    lazy var fakeBar: HandyNavigationBar = FakeNavigationBar()
    lazy var fromFakeBar: HandyNavigationBar = FakeNavigationBar()
    lazy var toFakeBar: HandyNavigationBar = FakeNavigationBar()
    var fakeBarBeginFrame: CGRect = .zero
    var alphaObserver: NSKeyValueObservation?
    var naviFrameObserver: NSKeyValueObservation?
    var fakeSuperView: UIView?
    weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func navigationBarUpdateFrame(){
        guard let navi = navigationController else { return }
        
        if navi.handy.navigationStyle == .none{
            return
        }
        navi.view.backgroundColor = .white
        for view in navi.navigationBar.subviews {
            if "_UIBarBackground" == NSStringFromClass(type(of: view)) {
                ///不知道为啥  模拟器偶尔会为负 .....
                if view.frame.origin.x<0 {
                    view.handy.left = 0
                }
//                view.layer.removeAnimation(forKey: "backgroundColor")
//                view.layer.removeAnimation(forKey: "opacity")
                if navi.handy.navigationStyle == .custom {
                    view.isUserInteractionEnabled = true
                }
                for subView in view.subviews {
                    if !(subView is HandyNavigationBar) {
                        subView.alpha = 0
                    }
                }
                if let top = navi.topViewController, !top.prefersStatusBarHidden, !top.handy.naviBarHidden, view.handy.top<0, navi.navigationBar.handy.top == 0{
                    navi.navigationBar.handy.top = -view.handy.top
                }
                
            }else if navi.handy.navigationStyle == .custom, "_UINavigationBarContentView" == NSStringFromClass(type(of: view)) {
                view.isHidden = true
                
                continue
            }
        }
        ///ios 13.0 需要添加  半屏弹出才会显示
        setupNavigationBar()
        fakerBarUpdateFrame()
    }
    
//    func findButtonLabel(view: UIView?)-> UIView?{
//        for
//        if let view = view, NSStringFromClass(type(of: view)) == "UIButtonLabel"{
//            return view
//        }else{
//            findButtonLabel(view: view.)
//            return nil
//        }
//    }
    func navigationController(willShow viewController: UIViewController, animated: Bool) {
        
        guard let navi = navigationController, navi.handy.navigationStyle != .none, !(viewController is UINavigationController) else { return }
        viewController.setNeedsStatusBarAppearanceUpdate()
        fakeBarBeginFrame = fakeBar.frame
        if let _ = navi.transitionCoordinator{
            showViewController(viewController)
        } else { //1. 初始化只有一个controller的时候  2. animated 为false的时候
            navi.handy.updateNavigationBar(for: viewController)
        }
        
    }
    func navigationController(didShow viewController: UIViewController, animated: Bool) {
        guard let navi = navigationController, navi.handy.navigationStyle != .none, !(viewController is UINavigationController) else { return }
        if animated {
            DispatchQueue.main.async {
                navi.handy.animationBlock?(true)
                navi.handy.animationBlock = nil
            }
        }else{
            navi.handy.animationBlock?(true)
            navi.handy.animationBlock = nil
        }
        /// 重新设置样式
        clearTempFakeBar()
        navi.handy.updateNavigationBar(for: viewController)
    }
    
    func fakerBarUpdateFrame(){
        guard let navi = navigationController, navi.handy.navigationStyle != .none else { return }
        if navi.topViewController?.handy.naviBarHidden == true  {
            return
        }
        var frame = navi.navigationBar.frame
        frame.origin.x = 0
        if frame.origin.y>=0, fakeBar.frame.origin.y >= 0, fakeBar.superview == fakeSuperView {
            let fakeFrame = CGRect.init(x: 0, y: frame.origin.y == 0 ? 0: HandyApp.statusBarHeight, width: navi.navigationBar.frame.size.width, height: navi.navigationBar.frame.size.height)
            fakeBar.frame = fakeFrame
            fakeBar.setNeedsLayout()
        }
        
        guard let coordinator = navi.transitionCoordinator, let toVC = coordinator.viewController(forKey: .to) else {
                  return
              }
        if frame.origin.y>=0, fakeBar.frame.origin.y <= 0, fakeBar.superview == toVC.view {
            fakeBar.frame = fakerBarFrame(for: toVC, originView: fakeBar)
            fakeBar.setNeedsLayout()
        }
    }
    
    func setupFakeSubviews(){
        guard let navi = navigationController, navi.handy.navigationStyle != .none else { return }
        if fakeSuperView == nil {
            fakeSuperView = navi.navigationBar.subviews.first
        }
        
        guard let fakeSuperView = fakeSuperView else {
            return
        }
        if alphaObserver == nil{
            alphaObserver = fakeSuperView.observe(\UIView.backgroundColor, options: [.old, .new]) { _, change in
                if change.newValue != change.oldValue {
                    fakeSuperView.backgroundColor = .clear
                }
            }
        }

        if naviFrameObserver == nil{
            naviFrameObserver = fakeSuperView.observe(\UIView.frame, options: [.old, .new]){ [weak self, weak navi] obj, change in
                if let navi = navi ,let _new = change.newValue, let _old = change.oldValue, _new.equalTo(_old){
                    if _new.origin.y == 0, navi.navigationBar.frame.origin.y>0{
                        var frame = _new
                        frame.origin.y = -navi.navigationBar.frame.origin.y
                        frame.size.height = navi.navigationBar.frame.origin.y + navi.navigationBar.frame.size.height
                        if navi.transitionCoordinator == nil{
                            navi.navigationBar.handy.top = self?.getStatusHeight() ?? 0
                        }
                        obj.frame = frame
                    }
                }
            }
        }
        
        if fakeBar.superview == nil {
            fakeSuperView.insertSubview(fakeBar, at: 0)
            navi.view.setNeedsLayout()
            let originY = navi.navigationBar.frame.origin.y
            if (originY >= 0){
                fakeBar.frame = CGRect.init(x: 0, y: originY == 0 ? 0 : HandyApp.statusBarHeight, width: navi.navigationBar.frame.size.width, height: navi.navigationBar.frame.size.height)
                fakeBar.setNeedsLayout()
            }
            
        }
    }

    
    func setupNavigationBar() {
        guard let navi = navigationController, navi.handy.navigationStyle != .none else { return }
        if navi.handy.navigationStyle == .custom , let top = navi.topViewController {
            fakeBar = top.handy.customNaviBar!
        }
        navi.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navi.navigationBar.shadowImage = UIImage()
        navi.navigationBar.barTintColor = UIColor.clear
        setupFakeSubviews()
    }
    
    func showViewController(_ viewController:UIViewController){
        guard let navi = navigationController, navi.handy.navigationStyle != .none , let coordinator = viewController.transitionCoordinator, let fromVC = coordinator.viewController(forKey: .from),
              let toVC = coordinator.viewController(forKey: .to), !(fromVC is UINavigationController), !(toVC is UINavigationController) else {
                  return
              }
        
        if toVC.handy.naviBarHidden{
            fromVC.view.addSubview(fakeBar)
            fakeBar.frame = fakerBarFrame(for: fromVC, originView: fakeBar)
        }else if fromVC.handy.naviBarHidden{
            toVC.view.addSubview(fakeBar)
            fakeBar.frame = fakerBarFrame(for: toVC, originView: fakeBar)
        }else{
            fakeBar.removeFromSuperview()
            fakeBar.frame = navi.navigationBar.frame
            navi.view.insertSubview(fakeBar, belowSubview: navi.navigationBar)
        }
        fakeBar.setNeedsLayout()
        self.fakeSuperView?.backgroundColor = .clear

        coordinator.notifyWhenInteractionChanges { context in
            if navi.handy.navigationStyle != .custom {
                if !context.isCancelled{
                    tsPopMiddleDuration = min(context.transitionDuration*(1-context.percentComplete)*0.3, 0.1)
                    navi.needDisplayPop()
                }else{
                    if fromVC.handy.naviBarHidden {
                        navi.handy.updateNavigationBar(for: toVC)
                    }else{
                        navi.handy.updateNavigationBar(for: fromVC)
                    }

                    if HandyApp.isIphoneX || toVC.handy.naviBarHidden || fromVC.handy.naviBarHidden {
                        return
                    }
                    UIView.animate(withDuration: 0.2) {
                        navi.navigationBar.frame = self.fakeBarBeginFrame
                        self.fakeBar.frame = self.fakeBarBeginFrame
                        self.fakeBar.layoutIfNeeded()
                    }
                }
            }
        }
        showTempFakeBar(fromVC: fromVC, toVC: toVC, ignoreTintColor: coordinator.isInteractive)
        coordinator.animate(alongsideTransition: { (context) in
            let isRootVC = viewController == navi.viewControllers.first
            if !isRootVC, viewController.isViewLoaded {
                self.installsLeftBarButtonItemIfNeeded(for: viewController)
            }
        }) { (context) in
            ///手势取消动画完成执行
            if context.isCancelled {
                /// 重新设置样式
                self.clearTempFakeBar()
                navi.handy.updateNavigationBar(for: fromVC)
            }else{
                self.navigationController(didShow: toVC, animated: context.isAnimated)
            }
            
        }
        
    }
    
    func showTempFakeBar(fromVC: UIViewController, toVC: UIViewController, ignoreTintColor : Bool = false) {
        guard let navi = navigationController, navi.handy.navigationStyle != .none else { return }
        
        UIView.setAnimationsEnabled(false)
        
        if navi.handy.navigationStyle == .system {
            if toVC.handy.naviBarHidden {
                navi.handy.updateNavigationBar(for: fromVC)
            }else {
                navi.handy.updateNavigationBar(for: toVC)
            }
            if ignoreTintColor {
                navi.navigationBar.tintColor = fromVC.handy.naviTintColor
            }

            fakeBar.handy.backgroundAlpha = fromVC.handy.naviBarAlpha
            fakeBar.barTintColor = fromVC.handy.naviBackgroundColor
            if toVC.handy.naviBackgroundImage == nil && fromVC.handy.naviBackgroundImage != nil {
                fakeBar.backImageView.image = fromVC.handy.naviBackgroundImage
            }
            if !toVC.handy.naviBarHidden && !fromVC.handy.naviBarHidden {
                if fakeBar.isTranslucent {
                    fakeBar.backgroundView.backgroundColor = .clear
                    fakeBar.barTintColor = fromVC.handy.naviBackgroundColor
                }else{
                    fakeBar.barTintColor = .clear
                    fakeBar.backgroundView.backgroundColor = fromVC.handy.naviBackgroundColor
                }
            }
        }else{
            navi.handy.updateNavigationBarTint(for: toVC)
            if ignoreTintColor {
                navi.navigationBar.tintColor = fromVC.handy.naviTintColor
            }
            fakeBar.isHidden = true
            if navi.handy.navigationStyle == .custom {
                fromFakeBar = fromVC.handy.customNaviBar!
                toFakeBar = toVC.handy.customNaviBar!
            }

            fromFakeBar.updateBarBackground(for: fromVC)
            fromFakeBar.updateBarShadow(for: fromVC)
            toFakeBar.updateBarBackground(for: toVC)
            toFakeBar.updateBarShadow(for: toVC)
            fromFakeBar.isHidden = fromVC.handy.naviBarHidden
            toFakeBar.isHidden = toVC.handy.naviBarHidden

            
            toFakeBar.layer.shadowColor = toVC.view.layer.shadowColor
            toFakeBar.layer.shadowOffset = toVC.view.layer.shadowOffset
            toFakeBar.layer.shadowRadius = toVC.view.layer.shadowRadius
            toFakeBar.layer.shadowOpacity = toVC.view.layer.shadowOpacity
            
            
            fromFakeBar.layer.shadowColor = fromVC.view.layer.shadowColor
            fromFakeBar.layer.shadowOffset = fromVC.view.layer.shadowOffset
            fromFakeBar.layer.shadowRadius = fromVC.view.layer.shadowRadius
            fromFakeBar.layer.shadowOpacity = fromVC.view.layer.shadowOpacity
            
            
            if toVC.view.superview == nil || (fromVC.view.superview != nil && NSStringFromClass(type(of: fromVC.view.superview!)) == "_UIParallaxDimmingView" || NSStringFromClass(type(of: toVC.view.superview!)) == "_UIParallaxDimmingView")  {
                ///适配ios 11  系统默认转场状态
                toVC.view.addSubview(toFakeBar)
                fromVC.view.addSubview(fromFakeBar)
            }else{
                toVC.view.superview?.insertSubview(toFakeBar, aboveSubview: toVC.view)
                fromVC.view.superview?.insertSubview(fromFakeBar, aboveSubview: fromVC.view)
            }
           
            fromFakeBar.frame = fakerBarFrame(for: fromVC, originView: fromFakeBar)
            toFakeBar.frame = fakerBarFrame(for: toVC, originView: toFakeBar)
            fromFakeBar.setNeedsLayout()
            toFakeBar.setNeedsLayout()
        
        }
        
        UIView.setAnimationsEnabled(true)
    }
    
    func systemContentViewShow(flag: Bool){
        guard let navi = navigationController else { return }
        for view in navi.navigationBar.subviews {
            if "_UINavigationBarContentView" == NSStringFromClass(type(of: view)) {
                view.isHidden = !flag
                continue
            }
        }
    }
    
    func updateNavigationBar(fromVC: UIViewController, toVC: UIViewController, progress: CGFloat, stratProgress: CGFloat? = nil){
        guard let navi = navigationController, navi.handy.navigationStyle != .none else { return }
        
        var titleTextAttributes = fakeBar.titleTextAttributes ?? [:]
        var foregroundFromColor = fromVC.handy.naviTitleColor
        var tintFromColor = fromVC.handy.naviTintColor
        if let start = stratProgress {
            foregroundFromColor = UIColor.handy.average(fromColor: fromVC.handy.naviTitleColor, toColor: toVC.handy.naviTitleColor, percent: start)
            tintFromColor = UIColor.handy.average(fromColor: fromVC.handy.naviTintColor, toColor: toVC.handy.naviTintColor, percent: start)
        }
        
        titleTextAttributes[.foregroundColor] = UIColor.handy.average(fromColor: foregroundFromColor, toColor: toVC.handy.naviTitleColor, percent: progress)
        navi.navigationBar.tintColor = UIColor.handy.average(fromColor: tintFromColor, toColor: toVC.handy.naviTintColor, percent: progress)
        
        if navi.handy.navigationStyle == .system {
            var barTintFromColor = fromVC.handy.naviBackgroundColor
            var bgAlphaFrom = fromVC.handy.naviBarAlpha
            if let start = stratProgress {
                barTintFromColor = UIColor.handy.average(fromColor: fromVC.handy.naviBackgroundColor, toColor: toVC.handy.naviBackgroundColor, percent: start)
                bgAlphaFrom = CGFloat.handy.middleValue(from: fromVC.handy.naviBarAlpha, to: toVC.handy.naviBarAlpha, percent: start)
            }
            
            if toVC.handy.naviBackgroundImage == nil, fromVC.handy.naviBackgroundImage != nil {
                
                fakeBar.backImageView.image = fromVC.handy.naviBackgroundImage
                fakeBar.backImageView.alpha = CGFloat.handy.middleValue(from: bgAlphaFrom, to: 0, percent: progress)
            }
            
            let color = UIColor.handy.average(fromColor: barTintFromColor, toColor: toVC.handy.naviBackgroundColor, percent: progress)
            
            fakeBar.isTranslucent = toVC.handy.naviIsTranslucent
            if toVC.handy.naviBarHidden {
                fakeBar.isTranslucent = fromVC.handy.naviIsTranslucent
            }
            
            fakeBar.handy.backgroundAlpha = CGFloat.handy.middleValue(from: bgAlphaFrom, to: toVC.handy.naviBarAlpha, percent: progress)
            
            if !toVC.handy.naviBarHidden && !fromVC.handy.naviBarHidden {
                if fakeBar.isTranslucent {
                    fakeBar.backgroundView.backgroundColor = .clear
                    fakeBar.barTintColor = color
                }else{
                    fakeBar.barTintColor = .clear
                    fakeBar.backgroundView.backgroundColor = color
                }
            }
            
        }
        
        if !toVC.handy.naviBarHidden && !fromVC.handy.naviBarHidden, !HandyApp.isIphoneX, navi.view.frame.size.height == HandyApp.screenHeight, toVC.handy.statusBarHidden != fromVC.handy.statusBarHidden{
            let fromY = fakeBarBeginFrame.origin.y
            let toY = toVC.handy.statusBarHidden ? 0 : getStatusHeight()
            let  originY = CGFloat.handy.middleValue(from: fromY, to: toY, percent: progress)
            navi.navigationBar.handy.top = originY
            fakeBar.handy.top = originY
            fakeBar.setNeedsLayout()
        }
        
        
        
        if toVC.handy.naviBarHidden {
            fakeBar.updateBarBackground(for: fromVC)
            fakeBar.updateBarShadow(for: fromVC)
            titleTextAttributes[.foregroundColor] = fromVC.handy.naviTitleColor
            navi.navigationBar.tintColor = fromVC.handy.naviTintColor
        }
        if fromVC.handy.naviBarHidden {
            titleTextAttributes[.foregroundColor] = toVC.handy.naviTitleColor
            fakeBar.updateBarBackground(for: toVC)
            fakeBar.updateBarShadow(for: toVC)
            navi.navigationBar.tintColor = toVC.handy.naviTintColor
        }
        navi.navigationBar.titleTextAttributes = titleTextAttributes
    }
    
    func fakerBarFrame(for viewController: UIViewController, originView: UIView) -> CGRect {
        guard let navi = navigationController, navi.handy.navigationStyle != .none else { return .zero}
        var originFrame = CGRect.zero
        if (originView == fromFakeBar || originView == fakeBar), !originView.frame.equalTo(.zero){
            originFrame = originView.frame
            
            if !viewController.handy.statusBarHidden, !viewController.handy.naviBarHidden, originFrame.origin.y == 0, HandyApp.screenHeight == navi.view.frame.size.height{
                originFrame.origin.y = getStatusHeight()
            }
            if navi.navigationBar.frame.origin.y != 0{
                originFrame.origin.y = navi.navigationBar.frame.origin.y
            }
        }else{
            originFrame = navi.navigationBar.frame
            if viewController.handy.statusBarHidden, originFrame.origin.y>0, !HandyApp.isIphoneX {
                originFrame.origin.y = 0
            }
            if !viewController.handy.naviBarHidden, !viewController.handy.statusBarHidden, originFrame.origin.y == 0, HandyApp.screenHeight == navi.view.frame.size.height{
                originFrame.origin.y = getStatusHeight()
            }
            ///解决横屏的时候 navigation 高度不准确
            if originFrame.size.height != fakeBarBeginFrame.size.height, fakeBar == originView {
                originFrame.size.height = fakeBarBeginFrame.size.height
            }
        }
        if originFrame.size.height == 0{
            originFrame.size.height = HandyApp.naviBarHeight-HandyApp.statusBarHeight
        }
        
        var frame = navi.navigationBar.superview?.convert(originFrame, to: viewController.view) ?? .zero
        if viewController.view == originView.superview {
            frame = viewController.view.convert(originFrame, to: viewController.view)
            if !viewController.handy.naviIsTranslucent {
                frame.origin.y = -originFrame.size.height
            }
        }
        if originView.superview is HandyTransitionContainerView{
            frame = UIApplication.shared.windows.first?.convert(originFrame, to: nil) ?? .zero
        }
        
        if let _superview = originView.superview as? UIScrollView{
            frame.origin.y += _superview.contentOffset.y
        }
        frame.origin.x = viewController.view.frame.origin.x
        return frame
    }
    
    ///重新设置farkBar
    func clearTempFakeBar() {
        guard let navi = navigationController, navi.handy.navigationStyle != .none else { return }
        fakeBar.removeFromSuperview()
        fromFakeBar.removeFromSuperview()
        toFakeBar.removeFromSuperview()
        if navi.handy.navigationStyle == .custom , let top = navi.topViewController {
            fakeBar = top.handy.customNaviBar!
            fakeBar.removeFromSuperview()
        }
        setupFakeSubviews()
        fakeBarBeginFrame = fakeBar.frame
        fakeBar.isHidden = false
    }
    
    func installsLeftBarButtonItemIfNeeded(for viewController: UIViewController){
        guard let navi = navigationController else { return }
        let isRootVC = viewController == navi.viewControllers.first
        
        let hasSetLeftItem =  viewController.handy.navigationItem.leftBarButtonItem != nil
        
        if !isRootVC && !hasSetLeftItem {
            if navi.handy.useSystemBackBarButtonItem{
                if navi.handy.navigationStyle == .custom  {
                    let path = Bundle.init(for: HandyNavigationBar.self).path(forResource: "Handy", ofType: "bundle")
                    let item = HandyBarButtonItem.init(image: UIImage.handy.image(for: "icon_back", from: path), style: .done, target: self, action: #selector(onBack(_:)))
                    viewController.handy.navigationItem.leftBarButtonItem = item
                }else{
                    viewController.navigationItem.leftBarButtonItem = navi.handy.barBackItem
                }
            }else{
                if let item = (viewController as? HandyNavigationItemCustomizable)?.handy_customBackItem?(self, action: #selector(onBack(_:))){
                    viewController.handy.navigationItem.leftBarButtonItem = item
                }else{
                    viewController.handy.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: NSLocalizedString("Back", comment: ""), style: .plain, target: self, action: #selector(onBack(_:)))
                }
            }
            
        }
    }
    
    @objc private func onBack(_ item: UIBarButtonItem){
        navigationController?.popViewController(animated: true)
    }
    
    func getStatusHeight() -> CGFloat{
        var statusFrame = CGRect.zero
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene{
                statusFrame = scene.statusBarManager?.statusBarFrame ?? .zero
            }
            
        }else{
            statusFrame = UIApplication.shared.statusBarFrame
        }
        return statusFrame.size.height
    }
    deinit {
        alphaObserver?.invalidate()
        naviFrameObserver?.invalidate()
        naviFrameObserver = nil
        alphaObserver = nil
    }
}

class HandyBarButtonItem: UIBarButtonItem{}

extension UINavigationBar{
    fileprivate struct UINavigationBarKeys {
        static var backgroundAlpha = "UINavigationBarKeys_backgroundAlpha"
    }
}

extension HandyExtension where Base: UINavigationBar{
    
    var backgroundAlpha: CGFloat {
        get {
            return objc_getAssociatedObject(base, &type(of: base).UINavigationBarKeys.backgroundAlpha) as? CGFloat ?? 1
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).UINavigationBarKeys.backgroundAlpha, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let classNames = ["_UIBarBackground","_UINavigationBarBackground"]
            for view in base.subviews {
                if classNames.contains(NSStringFromClass(type(of: view))) {
                    view.alpha = newValue
                    continue
                }
            }
        }
    }
}
