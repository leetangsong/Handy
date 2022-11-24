//
//  HandySwizzling.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//

import UIKit

public protocol HandySwizzling: AnyObject{
    static func awake()
    static func addSwizzlingMethod(cls: AnyClass, sel: Selector)
}

var HandySwizzlingMethods: [String] = []
 
public extension HandySwizzling{
    static func addSwizzlingMethod(cls: AnyClass, sel: Selector){
        let str = NSStringFromClass(cls) + "&" + NSStringFromSelector(sel)
        assert(!HandySwizzlingMethods.contains(str), "\(NSStringFromClass(cls))已实现过该方法")
        HandySwizzlingMethods.append(str)
    }
}
class HandySwizzles: NSObject, HandySwizzling{
    static func awake() {
        addSwizzlingMethod(cls: UIControl.self, sel: #selector(UIControl.controlSwizzling))
    }
}
extension NSObject{
    
    public class func addSwizzling(originMethod: Selector, swizzledMethod: Selector){
        swizzlingForClass(self, originalSelector: originMethod, swizzledSelector: swizzledMethod)
    }
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
   
    public static func runOnce() {
        NothingToSeeHere.harmlessFunction()
        for string in HandySwizzlingMethods{
            let array = string.components(separatedBy: "&")
            guard array.count>1 , let cls = NSClassFromString(array[0]) as? NSObjectProtocol else{
                return
            }
            let sel = Selector(array[1])
            
            if cls.responds(to: sel){
                cls.perform(sel)
            }
        }
    }
    
}
extension NSObject: HandyClassCompatible{}


