//
//  ThemePicker.swift
//  Handy
//
//  Created by leetangsong on 2022/10/20.
//

import UIKit

@objc open class ThemePicker: NSObject, NSCopying {
    
    public typealias ValueType = () -> Any?
    
    public var value: ValueType
    
    required public init(v: @escaping ValueType) {
        value = v
    }
    
    public func copy(with zone: NSZone?) -> Any {
        return type(of: self).init(v: value)
    }
    
}

@objc public extension ThemePicker {
    
    class func getThemePicker(
        _ object : NSObject,
        _ selector : String
    ) -> ThemePicker? {
        return object.theme.themePickers[selector]
    }

    class func setThemePicker(
        _ object : NSObject,
        _ selector : String,
        _ picker : ThemePicker?
    ) {
        object.theme.themePickers[selector] = picker
        object.performThemePicker(selector: selector, picker: picker)
    }

    class func makeStatePicker(
        _ object : NSObject,
        _ selector : String,
        _ picker : ThemePicker?,
        _ state : UIControl.State
    ) -> ThemePicker? {
        
        var picker = picker
        
        if let statePicker = object.theme.themePickers[selector] as? ThemeStatePicker {
            picker = statePicker.setPicker(picker, forState: state)
        } else {
            picker = ThemeStatePicker(picker: picker, withState: state)
        }
        return picker
    }
}

