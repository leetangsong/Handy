//
//  UIButton+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//


import UIKit
#if canImport(IQKeyboardManager)
import IQKeyboardManager
#endif

#if canImport(RxCocoa)
import RxCocoa
#endif

class HandyCoreSwizzling: NSObject, HandySwizzling{
    static func awake() {
        addSwizzlingMethod(cls: UIButton.self, sel: #selector(UIButton.handyButtonSwizzling))
    }
    
}



public extension UIButton{
    
    fileprivate struct AssociatedKeys {
        static var enlargedInsets = "enlargedInsets"
        static var touchEndEditing = "touchEndEditing"
        static var imagePosition = "imagePosition"
        static var spacing = "spacing"
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let rect = handy.enlargedRect
        if rect.equalTo(self.bounds){
            return super.hitTest(point, with: event);
        }
        return rect.contains(point) ? self : nil;
    }
    
    @objc static func handyButtonSwizzling(){
        let originalMethods = [
            #selector(UIButton.layoutSubviews)
        ]
        let swizzledMethods = [
            #selector(UIButton.handy_layoutSubviews)
        ]

        for (i, originalMethod) in originalMethods.enumerated() {
            swizzlingForClass(UIButton.self, originalSelector: originalMethod, swizzledSelector: swizzledMethods[i])
        }
    }
    
    
    @objc private func handy_layoutSubviews() {
        handy_layoutSubviews()
        guard let imagePosition = handy.imagePosition else { return }
        
        var imageFrame = CGRect.init(origin: .zero, size: currentImage?.size ?? .zero)
        var labelFrame = CGRect.zero
        
        switch imagePosition {
        case .top, .bottom:  //图片在上面
            let maxHeight = bounds.size.height - imageFrame.size.height - (currentImage == nil ? 0 : handy.spacing)
            var labelSize = getLabelSize(CGSize.init(width: bounds.size.width, height: maxHeight))
            if labelSize.width >  bounds.size.width{
                labelSize.width = bounds.size.width
            }
            
            if labelSize.height > maxHeight{
                labelSize.height = maxHeight
            }
            labelFrame.size = labelSize
            var topFrame = imageFrame
            var bottomFrame = labelFrame
            if imagePosition == .bottom{
                topFrame = labelFrame
                bottomFrame = imageFrame
            }
                
            var vMargin = (maxHeight - labelSize.height)/2
            var x: CGFloat = 2
            
            if contentVerticalAlignment == .top{
                vMargin = 0
            }else if contentVerticalAlignment == .bottom{
                vMargin *= 2
            }
            
            if contentHorizontalAlignment == .left{
                x = 0
            }else if contentHorizontalAlignment == .right{
                x = 1
            }
            topFrame.origin.y = vMargin
            bottomFrame.origin.y = topFrame.maxY +  handy.spacing
            
            topFrame.origin.x = (bounds.size.width - topFrame.size.width)/x
            bottomFrame.origin.x = (bounds.size.width - bottomFrame.size.width)/x
            
            if imagePosition == .top{
                imageView?.frame = topFrame
                titleLabel?.frame = bottomFrame
            }else{
                imageView?.frame = bottomFrame
                titleLabel?.frame = topFrame
            }
            
            break
        case .right, .left:
            let maxWidth = bounds.size.width - imageFrame.size.width - (currentImage == nil ? 0 : handy.spacing)
            var labelSize = getLabelSize(CGSize.init(width: maxWidth, height: bounds.size.height))
            if labelSize.width >  maxWidth{
                labelSize.width = maxWidth
            }
            
            if labelSize.height > bounds.size.height{
                labelSize.height = bounds.size.height
            }
            labelFrame.size = labelSize
            var leftFrame = imageFrame
            var rightFrame = labelFrame
            if imagePosition == .right{
                leftFrame = labelFrame
                rightFrame = imageFrame
            }
                
            var xMargin = (maxWidth - labelSize.width)/2
            var y: CGFloat = 2
            
            if contentHorizontalAlignment == .left{
                xMargin = 0
            }else if contentHorizontalAlignment == .right{
                xMargin *= 2
            }
            
            if contentVerticalAlignment == .top{
                y = 0
            }else if contentVerticalAlignment == .bottom{
                y = 1
            }
            leftFrame.origin.x = xMargin
            rightFrame.origin.x = leftFrame.maxX + handy.spacing
            
            leftFrame.origin.y = (bounds.size.height - leftFrame.size.height)/y
            rightFrame.origin.y = (bounds.size.height - rightFrame.size.height)/y
            
            if imagePosition == .left{
                imageView?.frame = leftFrame
                titleLabel?.frame = rightFrame
            }else{
                imageView?.frame = rightFrame
                titleLabel?.frame = leftFrame
            }
            break
        }
    }
    
    private func getLabelSize(_ size: CGSize) -> CGSize{
        return titleLabel?.sizeThatFits(size) ?? .zero
    }
    
}




public extension HandyExtension where Base: UIButton{
    
    
    enum HandyButtonImagePosition {
        case top,bottom,left,right
    }
   
    fileprivate var imagePosition: HandyButtonImagePosition?{
        get{
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.imagePosition) as? HandyButtonImagePosition
        }
        set{
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.imagePosition, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var spacing: CGFloat{
        get{
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.spacing) as? CGFloat ?? 0
        }
        set{
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.spacing, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    fileprivate var enlargedRect: CGRect{
        guard let enlarged = enlargedInsets else {
            return base.bounds
        }
        return CGRect.init(x: base.bounds.origin.x - enlarged.left, y: base.bounds.origin.y - enlarged.top, width: base.bounds.size.width + enlarged.left + enlarged.right, height: base.bounds.size.height + enlarged.top + enlarged.bottom)
    }
    
    
    
    
    
    fileprivate var enlargedInsets: UIEdgeInsets?{
        get{
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.enlargedInsets) as? UIEdgeInsets
        }
        set{
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.enlargedInsets, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    ///扩大点击区域
    func enlarged(with insets: UIEdgeInsets){
        enlargedInsets = insets
    }

    /// 点击是否 隐藏 输入键盘
    var touchEndEditing: Bool?{
        get{
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.touchEndEditing) as? Bool
        }
        set{
            if self.touchEndEditing == nil{
#if canImport(RxCocoa)
                _ = self.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self]_ in
                    if self?.touchEndEditing == true{
#if canImport(IQKeyboardManager)
                        IQKeyboardManager.shared().resignFirstResponder()
#endif
                    }
                })
#else
                viewController?.view.endEditing(true)
#endif
                
            }
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.touchEndEditing, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //改变图片与按钮的位置
    func adjustButton(with imagePosition: HandyButtonImagePosition, spacing: CGFloat){
        self.imagePosition = imagePosition
        self.spacing = spacing
    }
    
}

extension UIButton{
    
}
