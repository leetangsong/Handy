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
        return statusBarHeight + 44
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
        if #available(iOS 11.0, *) {
            let insets = window?.safeAreaInsets ?? .zero
            return insets
        }
        
        return .zero
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
    
    
}
