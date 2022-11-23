//
//  UIButton+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//


import UIKit

public extension UIButton{
    
    fileprivate struct AssociatedKeys {
        static var enlargedInsets = "enlargedInsets"
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let rect = handy.enlargedRect
        if rect.equalTo(self.bounds){
            return super.hitTest(point, with: event);
        }
        return rect.contains(point) ? self : nil;
    }
}

public extension HandyExtension where Base: UIButton{
    
    
    enum HandyButtonMode {
        case top,bottom,left,right
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

    //改变图片与按钮的位置  
    func adjustButton(with model: HandyButtonMode, spacing: CGFloat){
        let imageWidth = base.currentImage?.size.width ?? 0
        let imageHeight = base.currentImage?.size.height ?? 0
        var size = CGSize.zero
        if let font = base.titleLabel?.font{
            size = NSString.init(string: base.currentTitle ?? "").size(withAttributes: [.font:font])
        }
        
        if size.width > (base.titleLabel?.frame.width ?? 0) && (base.titleLabel?.handy.width ?? 0) > 0 {
            size.width = base.titleLabel?.frame.width ?? 0
        }
        let labelWidth = size.width
        let labelHeight = size.height
        
        let imageOffsetX = (imageWidth + labelWidth)/2 - imageWidth/2 //image中心移动的x距离
        let imageOffsetY = imageHeight/2 + spacing/2 //image中心移动的y距离
        let labelOffsetX = (imageWidth + labelWidth/2) - (imageWidth + labelWidth)/2 //label中心移动的x距离
        let labelOffsetY = labelHeight/2 + spacing/2 //label中心移动的y距离
        
        let tempWidth = max(labelWidth, imageWidth)
        let changedWidth = labelWidth + imageWidth - tempWidth
        let tempHeight = max(labelHeight, imageHeight)
        let changedHeight = labelHeight + imageHeight + spacing - tempHeight
        
        var imageEdgeInsets = UIEdgeInsets.zero
        var titleEdgeInsets = UIEdgeInsets.zero
        var contentEdgeInsets = UIEdgeInsets.zero
        
        switch model {
            case .left:
                imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
                titleEdgeInsets = UIEdgeInsets.init(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
                contentEdgeInsets = UIEdgeInsets.init(top: 0, left: spacing/2, bottom: 0, right: spacing/2)
                    
            case .right:
                imageEdgeInsets = UIEdgeInsets.init(top: 0, left: labelWidth + spacing/2, bottom: 0, right: -(labelWidth + spacing/2))
                titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(imageWidth + spacing/2), bottom: 0, right: imageWidth + spacing/2)
                contentEdgeInsets = UIEdgeInsets.init(top: 0, left: spacing/2, bottom: 0, right: spacing/2)
                
            case .top:
                imageEdgeInsets = UIEdgeInsets.init(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
                titleEdgeInsets = UIEdgeInsets.init(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
                contentEdgeInsets = UIEdgeInsets.init(top: imageOffsetY, left: -changedWidth/2, bottom: changedHeight-imageOffsetY, right: -changedWidth/2)
                
            case .bottom:
                imageEdgeInsets = UIEdgeInsets.init(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
                titleEdgeInsets = UIEdgeInsets.init(top: -labelOffsetY, left: -labelOffsetX, bottom: labelOffsetY, right: labelOffsetX)
                contentEdgeInsets = UIEdgeInsets.init(top: changedHeight-imageOffsetY, left: -changedWidth/2, bottom: imageOffsetY, right: -changedWidth/2)
        }
        base.imageEdgeInsets = imageEdgeInsets
        base.titleEdgeInsets = titleEdgeInsets
        base.contentEdgeInsets = contentEdgeInsets
    }
    
}
