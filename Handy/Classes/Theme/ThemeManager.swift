//
//  ThemeManager.swift
//  Handy
//
//  Created by leetangsong on 2022/10/19.
//

import UIKit

public protocol ThemeCompatible: AnyObject { }
public class ThemeExtension<Base>: NSObject {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}
extension ThemeCompatible {
    public var theme: ThemeExtension<Self> {
        get{ return ThemeExtension(self) }
        set{ }
    }
}


public enum ThemePath {
    
    case mainBundle
    case sandbox(Foundation.URL)
    
    public var URL: Foundation.URL? {
        switch self {
        case .mainBundle        : return nil
        case .sandbox(let path) : return path
        }
    }
    
    public func plistPath(name: String) -> String? {
        return filePath(name: name, ofType: "plist")
    }
    
    public func jsonPath(name: String) -> String? {
        return filePath(name: name, ofType: "json")
    }
    
    private func filePath(name: String, ofType type: String) -> String? {
        switch self {
        case .mainBundle:
            return Bundle.main.path(forResource: name, ofType: type)
        case .sandbox(let path):
            let name = name.hasSuffix(".\(type)") ? name : "\(name).\(type)"
            let url = path.appendingPathComponent(name)
            return url.path
        }
    }
}


@available(iOS 13.0, *)
@objc public enum  ThemeSystemStyle: Int{
    case linght = 0
    case dark
}

@objc public final class ThemeManager: NSObject {
    public static var animationDuration: CGFloat = 0.3
    ///是否跟随系统主题变化
    @available(iOS 13.0, *)
    public static var isFollowSystemTheme: Bool = false{
        didSet{
            assert(followSystemThemeAction != nil, "未设 置followSystemThemeAction")
            followSystemThemeAction?(systemThemeStyle)
        }
    }
    @available(iOS 13.0, *)
    public static var followSystemThemeAction: ((_ style: ThemeSystemStyle) -> Void)?
    
    ///是否是系统主题按钮改变
    static var fromSystemChange: Bool = false
    
    static var themePickers: [ThemePickerHelper] = []
    
    @objc public fileprivate(set) static var currentTheme: NSDictionary?
    
    @objc public fileprivate(set) static var currentThemeIndex: Int = 0
    
    public fileprivate(set) static var currentThemePath: ThemePath?
        
    
    private static var themeChangeLock: NSLock = NSLock()
    fileprivate static var themeSystemChangeLock: NSLock = NSLock()
    
    
    @available(iOS 13.0, *)
    public static var systemThemeStyle: ThemeSystemStyle{
        return  getSystemStyle(from: _userInterfaceStyle)
    }
    @available(iOS 13.0, *)
    private static var _userInterfaceStyle: UIUserInterfaceStyle?{
        didSet{
            if _userInterfaceStyle != oldValue{
                followSystemThemeAction?(systemThemeStyle)
            }
        }
    }
    
    @objc class func setTheme(index: Int) {
        currentThemeIndex = index
        themeChangeLock.lock()
        for helper in themePickers{
            helper.pickerHelper()
        }
        themeChangeLock.unlock()
    }
    
    
    
    public class func setTheme(plistName: String, path: ThemePath) {
        guard let plistPath = path.plistPath(name: plistName) else {
            print("Handy WARNING: Can't find plist '\(plistName)' at: \(path)")
            return
        }
        guard let plistDict = NSDictionary(contentsOfFile: plistPath) else {
            print("Handy WARNING: Can't read plist '\(plistName)' at: \(plistPath)")
            return
        }
        self.setTheme(dict: plistDict, path: path)
    }
    
    public class func setTheme(jsonName: String, path: ThemePath) {
        guard let jsonPath = path.jsonPath(name: jsonName) else {
            print("Handy WARNING: Can't find json '\(jsonName)' at: \(path)")
            return
        }
        guard
            let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)),
            let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
            let jsonDict = json as? NSDictionary else {
            print("Handy WARNING: Can't read json '\(jsonName)' at: \(jsonPath)")
            return
        }
        self.setTheme(dict: jsonDict, path: path)
    }
    
    class func setTheme(dict: NSDictionary, path: ThemePath) {
        currentTheme = dict
        currentThemePath = path
        themeChangeLock.lock()
        for helper in themePickers{
            helper.pickerHelper()
        }
        themeChangeLock.unlock()
    }
    
    @available(iOS 13.0, *)
    class func systemThemeChange(_ userInterfaceStyle: UIUserInterfaceStyle?){
        themeSystemChangeLock.lock()
        fromSystemChange = true
        _userInterfaceStyle = userInterfaceStyle
        fromSystemChange = false
        themeSystemChangeLock.unlock()
    }
    
    @available(iOS 13.0, *)
    private static func getSystemStyle(from userInterfaceStyle: UIUserInterfaceStyle?)-> ThemeSystemStyle {
        if let style = userInterfaceStyle{
            if style == .dark{
                return .linght
            }else{
                return .dark
            }
        }else {
            let style = UIViewController().traitCollection.userInterfaceStyle
            if style == .dark{
                return .dark
            }else{
                return .linght
            }
        }
    }
}




