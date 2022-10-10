//
//  HandyNavigationBar.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//

import UIKit

public class HandyNavigationBar: UINavigationBar {

    ///非透明的时候用这个
    lazy var backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    public var title: String?{
        didSet{
            item?.title = title
        }
    }
    public var item: UINavigationItem?{
        return topItem
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        ///设置了 item  才会显示背景
        pushItem(UINavigationItem(), animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateBar(for viewController: UIViewController){
        updateBarTint(for: viewController)
        updateBarShadow(for: viewController)
        updateBarBackground(for: viewController)
    }
    
    
    func updateBarTint(for viewController: UIViewController){
        tintColor = viewController.handy.naviTintColor
        var titleTextAttributes = self.titleTextAttributes ?? [:]
        titleTextAttributes[.font] = viewController.handy.naviTitleFont
        titleTextAttributes[.foregroundColor] = viewController.handy.naviTitleColor
        self.titleTextAttributes = titleTextAttributes
    }
    
    func updateBarBackground(for viewController: UIViewController) {
        barTintColor = viewController.handy.naviBackgroundColor
        isTranslucent = viewController.handy.naviIsTranslucent
        if viewController.handy.naviBackgroundImage != nil {
            isTranslucent = false
            barTintColor = nil
        }
        backImageView.image = viewController.handy.naviBackgroundImage
        if !isTranslucent {
            backgroundView.backgroundColor = viewController.handy.naviBackgroundColor
        }else{
            backgroundView.backgroundColor = .clear
        }
        
        backImageView.alpha = 1
        handy.backgroundAlpha = viewController.handy.naviBarAlpha
        
    }
    
    func updateBarShadow(for viewController: UIViewController) {
        shadowImage = viewController.handy.naviShadowHidden ? UIImage(): UIImage.handy.image(with: viewController.handy.naviShadowColor)
    }
    
    func setupFakeView(){
        
        guard let bsuperview = subviews.first else { return }
        
        if backImageView.superview == nil {
            bsuperview.insertSubview(backImageView, at: 0)
        }
        if backgroundView.superview == nil {
            bsuperview.insertSubview(backgroundView, at: 0)
        }
        var viewFrame = bsuperview.frame
        var originY = frame.origin.y
        if originY >= 0 {
            
            if originY>0 , originY != HandyApp.statusBarHeight {
                originY = HandyApp.statusBarHeight
            }
            viewFrame.origin.y = -originY
            viewFrame.size.height = frame.size.height + originY
            
        }else{
            if let superview = superview, superview.handy.height>HandyApp.naviBarHeight  {
                
                originY = HandyApp.screenHeight - superview.handy.height - abs(originY)
                if originY > 0 || superview is UIScrollView{
                    originY = HandyApp.statusBarHeight
                }
                viewFrame.origin.y = -originY
                viewFrame.size.height = frame.size.height + originY
            }
        }

        ///解决 部分机型 自定义 （custom）导航下  前一个导航栏与状态栏同时隐藏后， 导航栏向下偏移
//        if superview != nil, NSStringFromClass(type(of: superview!).self) == "_UIBarBackground"{
//            if superview!.handy.top == 0, frame.origin.y > 0{
//                viewFrame.origin.y  -= frame.origin.y
//            }
//        }
        bsuperview.frame = viewFrame
        bsuperview.alpha = handy.backgroundAlpha
        for subView in bsuperview.subviews {
            if backImageView != subView, subView is UIImageView  {
                subView.removeFromSuperview()
                break
            }
        }
        backImageView.frame = bsuperview.bounds
        backgroundView.frame = backImageView.frame
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupFakeView()
    }
    
}


class FakeNavigationBar: HandyNavigationBar{}
