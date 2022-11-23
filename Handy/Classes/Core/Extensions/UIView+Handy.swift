//
//  UIView+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//


import UIKit


extension UIView: HandyCompatible{}
public extension HandyExtension where Base: UIView {
    
    var width: CGFloat{
        get{
            return base.frame.size.width
        }
        set{
            var frame = base.frame
            frame.size.width = newValue
            base.frame = frame
        }
        
    }
    var height: CGFloat{
        get{
            return base.frame.size.height
        }
        set{
            var frame = base.frame
            frame.size.height = newValue
            base.frame = frame
        }
    }
    var centerX: CGFloat{
        get{
            return base.center.x
        }
        set{
            var center = base.center
            center.x = newValue
            base.center = center
        }
    }
    var centerY: CGFloat{
        get{
            return base.center.y
        }
        set{
            var center = base.center
            center.y = newValue
            base.center = center
        }
    }
    var maxX: CGFloat{
        return base.frame.maxX
    }
    var maxY: CGFloat{
        return base.frame.maxY
    }
    var mimX: CGFloat{
        return base.frame.minX
    }
    var mimY: CGFloat{
        return base.frame.minY
    }
    
    var origin : CGPoint {
        get{
            return  base.frame.origin
        }
        set{
            var frame = base.frame
            frame.origin = newValue
            base.frame = frame
        }
    }
    
    var left : CGFloat {
        get{
            return  base.frame.origin.x
        }
        set{
            var frame = base.frame
            frame.origin.x = newValue
            base.frame = frame
        }
    }
    
    var top : CGFloat {
        get{
            return  base.frame.origin.y
        }
        set{
            var frame = base.frame
            frame.origin.y = newValue
            base.frame = frame
        }
    }
    var size : CGSize {
        get{
            return  base.frame.size
        }
        set{
            var frame = base.frame
            frame.size = newValue
            base.frame = frame
        }
    }
  
    var right: CGFloat{
        get{
            assert(base.superview != nil, "未添加到父视图上")
            return base.superview!.handy.width - base.handy.maxX
        }
        set{
            assert(base.superview != nil, "未添加到父视图上")
            var frame = base.frame
            frame.origin.x += base.superview!.handy.width - newValue - base.handy.width
            base.frame = frame
        }
    }
    
    /// 切圆角
    /// - Parameters:
    ///   - viewSize: 大小， 未确定frame的时候  需要知道view的大小
    ///   - corners: 圆角位置
    ///   - radii: 圆角大小
    ///   - color: 边框颜色  nil 为无边框
    func cornerRadius(viewSize: CGSize? = nil, corners: UIRectCorner = .allCorners, radii: CGFloat ,color: UIColor? = nil){
        let rect = viewSize != nil ? CGRect.init(x: 0, y: 0, width: viewSize!.width, height: viewSize!.height) : base.bounds
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        base.layer.mask = maskLayer
        if color != nil {
            //添加border
            let borderLayer = CAShapeLayer()
            borderLayer.frame = rect
            borderLayer.path = maskPath.cgPath
            borderLayer.lineWidth = 0.5
            borderLayer.strokeColor = color!.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor
            
            let layers = base.layer.sublayers ?? []
            if let lastLayer = layers.last, lastLayer.isKind(of: CAShapeLayer.self) {
                layers.last?.removeFromSuperlayer()
            }
            base.layer.addSublayer(borderLayer)
        }
    }
    
    var viewController: UIViewController? {
        var next = base.superview
        while next != nil {
            let nextResponder = next?.next
            if nextResponder is UINavigationController ||
                nextResponder is UIViewController {
                return nextResponder as? UIViewController
            }
            next = next?.superview
        }
        return nil
    }
    
    /// UIView转UIImage
    /// - Returns: UIImage
    func convertedToImage(rect: CGRect = .zero) -> UIImage? {
        var size = base.bounds.size
        var origin = base.bounds.origin
        if !size.equalTo(rect.size) && !rect.isEmpty {
            size = rect.size
            origin = CGPoint(x: -rect.minX, y: -rect.minY)
        }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        base.drawHierarchy(in: CGRect(origin: origin, size: base.bounds.size), afterScreenUpdates: true)
//        let context = UIGraphicsGetCurrentContext()
//        layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


extension HandyClassExtension where Base == UIView {

}
