//
//  HandyWeakHost.swift
//  Handy
//
//  Created by leetangsong on 2023/1/10.
//

import UIKit


open class HandyWeakHost{
    required public init() {}
}

private var HandyWeakHostKey = "HandyWeakHostKey"
public extension NSObject {
    
    var weakHost: HandyWeakHost?{
        get {
            return objc_getAssociatedObject(self, &HandyWeakHostKey) as? HandyWeakHost
        }
        set {
            objc_setAssociatedObject(self, &HandyWeakHostKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    internal func getWeakHost<T: HandyWeakHost>(_ type: T.Type) -> T?{
        
        var weakHost = self.weakHost as? T
        if weakHost == nil{
            weakHost = type.init()
            self.weakHost = weakHost
        }
        return weakHost
    }
}
