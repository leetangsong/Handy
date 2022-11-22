//
//  HandyApp.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//

import UIKit

public struct HandyApp{
    public static var screenWidth: CGFloat{
        return UIScreen.main.bounds.size.width
    }
    public static var screenHeight: CGFloat{
        return UIScreen.main.bounds.size.height
    }
    
    public static var isVertical: Bool{
        return screenHeight>screenWidth
    }
    
    public static var statusBarHeight: CGFloat{
        return isIphoneX ? safeAreaInsets.top : 20
    }
    
    public static var naviBarHeight: CGFloat{
        if safeAreaInsets.top == 59 {
            return  53.6667 + 44
        }else{
            return  statusBarHeight + 44
        }
        
    }
    
    public static var tabBarHeight: CGFloat{
        return safeAreaInsets.bottom + 49
    }
    
    public static var isIphoneX: Bool{
        if screenHeight > screenWidth {
            return Int(screenHeight/screenWidth*100) == 216
        }else{
            return Int(screenWidth/screenHeight*100) == 216
        }
    }
    
    public static var safeAreaInsets: UIEdgeInsets{
        var window = UIApplication.shared.windows.first
        if (window?.isKeyWindow ?? false) == false  {
            if let keyWindow = UIApplication.shared.keyWindow {
                if keyWindow.bounds.equalTo(UIScreen.main.bounds) {
                    window = keyWindow
                }
            }
        }
        var insets: UIEdgeInsets = .zero
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return insets }
            guard let window = windowScene.windows.first else { return insets }
            insets = window.safeAreaInsets
        }else if #available(iOS 11.0, *) {
            insets = window?.safeAreaInsets ?? .zero
        }
        return insets
    }
    public static var safeAreaTop: CGFloat{
        return safeAreaInsets.top
    }
    public static var safeAreaBottom: CGFloat{
        return safeAreaInsets.bottom
    }
    
    //app名字
    public static let infoDict = Bundle.main.localizedInfoDictionary ?? Bundle.main.infoDictionary
    public static let appName = (infoDict?["CFBundleDisplayName"] ?? infoDict?["CFBundleName"]) as! String
    
    public static var modelName: String{
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
            ///iPod
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch 5"
        case "iPod7,1":  return "iPod Touch 6"
        case "iPod9,1":  return "iPod Touch 7"
            
            ///iPhone
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":  return "iPhone 5"
        case "iPhone5,2":  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":  return "iPhone 5s"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
        case "iPhone11,2":  return "iPhone XS"
        case "iPhone11,4","iPhone11,6": return "iPhone XS MAX"
        case "iPhone11,8" : return "iPhone XR"
        case "iPhone12,1" : return "iPhone 11"
        case "iPhone12,3":  return "iPhone 11 Pro"
        case "iPhone12,5" : return "iPhone 11 Pro Max"
        case "iPhone12,8" : return "iPhone SE 2"
        case "iPhone13,1" : return "iPhone 12 mini"
        case "iPhone13,2" : return "iPhone 12"
        case "iPhone13,3" : return "iPhone 12 Pro"
        case "iPhone13,4" : return "iPhone 12 Pro Max"
        case "iPhone14,4" : return "iPhone 13 mini"
        case "iPhone14,5" : return "iiPhone 13"
        case "iPhone14,2" : return "iPhone 13 Pro"
        case "iPhone14,3" : return "iPhone 13 Pro Max"
        case "iPhone14,7" : return "iiPhone 14"
        case "iPhone14,8" : return "iPhone 14 Plus"
        case "iPhone15,2" : return "iPhone 14 Pro"
        case "iPhone15,3" : return "iPhone 14 Pro Max"
            
            
            ///iPad
        case "iPad1,1": return "iPad"
        case "iPad1,2": return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":  return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":  return "iPad 4"
        case "iPad6,11","iPad6,12" : return "iPad 5"
        case "iPad7,5","iPad7,6" : return "iPad 6"
        case "iPad7,11","iPad7,12" : return "iPad 7"
        case "iPad11,6","iPad11,7" : return "iPad 8"
        case "iPad12,1","iPad12,2" : return "iPad 9"
            
            ///iPad Mini
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1","iPad5,2" : return "iPad mini 4"
        case "iPad11,1","iPad11,2" : return "iPad mini 5"
        case "iPad14,1","iPad14,2" : return "iPad mini 6"
            
            ///iPad Air
        case "iPad4,1", "iPad4,2", "iPad4,3":  return "iPad Air"
        case "iPad5,3","iPad5,4" : return "iPad Air 2"
        case "iPad11,3","iPad11,4" : return "iPad Air 3"
        case "iPad13,1","iPad13,2" : return "iPad Air 4"
        case "iPad13,16","iPad13,17" : return "iPad Air 5"
            
            ///iPad  pro
        case "iPad6,3","iPad6,4" : return "iPad Pro (9.7-inch)"
        case "iPad6,7","iPad6,8" : return "iPad Pro (12.9-inch)"
        case "iPad7,1","iPad7,2" : return "iPad Pro 2(12.9-inch)"
        case "iPad7,3","iPad7,4" : return "iPad Pro (10.5-inch)"
        case "iPad8,1","iPad8,2","iPad8,3","iPad8,4" : return "iPad Pro (11-inch)"
        case "iPad8,5","iPad8,6","iPad8,7","iPad8,8" : return "iPad Pro 3 (12.9-inch)"
        case "iPad8,9","iPad8,10" : return "iPad Pro 2 (11-inch)"
        case "iPad8,11","iPad8,12" : return "iPad Pro 4 (12.9-inch)"
        case "iPad13,4","iPad13,5","iPad13,6","iPad13,7" : return "iPad Pro 4 (11-inch)"
        case "iPad13,8","iPad13,9","iPad13,10","iPad13,11" : return "iPad Pro 5 (12.9-inch)"
            
            
            
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":  return "Apple TV 4"
            
            
            
        case "i386", "x86_64":  return "Simulator"
            
            ///iMac
        case "iMac21,1","iMac21,2" : return "iMac (24-inch, M1, 2021)"
            
            ///Mac mini
        case "Macmini9,1" : return "Mac mini (M1, 2020)"
            
            ///MacBook Air
        case "MacBookAir10,1" : return "MacBook Air (Late 2020)"
            
            ///MacBook Pro
        case "MacBookPro17,1" : return "MacBook Pro (13-inch, M1, 2020)"
        case "MacBookPro18,3","MacBookPro18,4" : return "MacBook Pro (14-inch, 2021)"
        case "MacBookPro18,1","MacBookPro18,2" : return "MacBook Pro (16-inch, 2021)"
            
        default:  return identifier
        }
        
    }
    
}
