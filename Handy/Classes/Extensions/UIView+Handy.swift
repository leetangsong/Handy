//
//  UIView+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//


import UIKit


extension UIView: HandyCompatible{}
extension UIView: HandyClassCompatible{ }

extension HandyExtension where Base: UIView {
    
    public var width: CGFloat{
        get{
            return base.frame.size.width
        }
        set{
            var frame = base.frame
            frame.size.width = newValue
            base.frame = frame
        }
        
    }
    public var height: CGFloat{
        get{
            return base.frame.size.height
        }
        set{
            var frame = base.frame
            frame.size.height = newValue
            base.frame = frame
        }
    }
    public var centerX: CGFloat{
        get{
            return base.center.x
        }
        set{
            var center = base.center
            center.x = newValue
            base.center = center
        }
    }
    public var centerY: CGFloat{
        get{
            return base.center.y
        }
        set{
            var center = base.center
            center.y = newValue
            base.center = center
        }
    }
    public var maxX: CGFloat{
        return base.frame.maxX
    }
    public var maxY: CGFloat{
        return base.frame.maxY
    }
    public var mimX: CGFloat{
        return base.frame.minX
    }
    public var mimY: CGFloat{
        return base.frame.minY
    }
    
    public var origin : CGPoint {
        get{
            return  base.frame.origin
        }
        set{
            var frame = base.frame
            frame.origin = newValue
            base.frame = frame
        }
    }
    
    public var left : CGFloat {
        get{
            return  base.frame.origin.x
        }
        set{
            var frame = base.frame
            frame.origin.x = newValue
            base.frame = frame
        }
    }
    
    public var top : CGFloat {
        get{
            return  base.frame.origin.y
        }
        set{
            var frame = base.frame
            frame.origin.y = newValue
            base.frame = frame
        }
    }
    public var size : CGSize {
        get{
            return  base.frame.size
        }
        set{
            var frame = base.frame
            frame.size = newValue
            base.frame = frame
        }
    }
  
    public var right: CGFloat{
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
    public func cornerRadius(viewSize: CGSize? = nil, corners: UIRectCorner = .allCorners, radii: CGFloat ,color: UIColor? = nil){
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
    
    
}


extension HandyClassExtension where Base == UIView {

}
