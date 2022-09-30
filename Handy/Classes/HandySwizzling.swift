//
//  HandySwizzling.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//

import UIKit

public protocol  HandySwizzling: AnyObject {
    static func awake()
}
extension HandySwizzling where Self: NSObject{
    public static func awake(){
        swizzling()
        otherSwizzling()
    }
}
extension NSObject{
    @objc public class func swizzling(){}
    @objc public class func otherSwizzling(){}
    public static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        guard (originalMethod != nil && swizzledMethod != nil) else {
            return
        }
        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
}
class NothingToSeeHere {
    public static func harmlessFunction() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? HandySwizzling.Type)?.awake()
        }
        types.deallocate()
    }
}

extension UIApplication {
    fileprivate struct AssociatedKeys {
        static var swizzlingClasses = "swizzlingClasses"
    }
    public static func runOnce() {
        for cls in handy.swizzlingClasses{
            cls.awake()
        }
//        NothingToSeeHere.harmlessFunction()
    }
    
}

extension UIApplication: HandyClassCompatible{}
extension HandyClassExtension where Base: UIApplication{
    static var swizzlingClasses: [HandySwizzling.Type]{
        get {
            if let classes = objc_getAssociatedObject(base, &base.AssociatedKeys.swizzlingClasses) as? [HandySwizzling.Type]{
                return classes
            }
            let classes: [HandySwizzling.Type] = [UIViewController.self, UINavigationController.self, UIButton.self, UIControl.self, UIView.self, UITabBarController.self, UITableView.self, UIScrollView.self, UICollectionView.self]
            self.swizzlingClasses = classes
            return classes
        }
        set {
            objc_setAssociatedObject(base, &base.AssociatedKeys.swizzlingClasses, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIViewController: HandySwizzling{}
extension UIView:HandySwizzling{}

