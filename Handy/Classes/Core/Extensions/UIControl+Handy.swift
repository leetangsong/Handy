//
//  UIControl+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//


import UIKit

extension UIControl{
    fileprivate struct AssociatedKeys {
        static var acceptEventInterval = "acceptEventInterval"
        static var acceptEventTime = "acceptEventInterval"
    }
}


public extension HandyExtension where Base: UIControl{
    var acceptEventInterval: TimeInterval? {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.acceptEventInterval) as? TimeInterval
        }
        set{
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.acceptEventInterval, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    fileprivate var acceptEventTime: TimeInterval {
        get {
            return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.acceptEventTime) as? TimeInterval ?? 0
        }
        set{
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.acceptEventTime, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


extension UIControl {
    @objc static func controlSwizzling() {
        let originalMethod = #selector(UIControl.sendAction(_:to:for:))
        let swizzledMethod = #selector(UIControl.handy_sendAction(_:to:for:))
        swizzlingForClass(UIControl.self, originalSelector: originalMethod, swizzledSelector: swizzledMethod)
    }
    
    //防止重复点击
    @objc private func handy_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        if let acceptEventInterval = handy.acceptEventInterval {
            if Date().timeIntervalSince1970 - handy.acceptEventTime < acceptEventInterval {
                return
            }
            handy.acceptEventTime = Date().timeIntervalSince1970
        }
        self.handy_sendAction(action, to: target, for: event)
    }
    
}
