//
//  UIApplication+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/10/26.
//

import UIKit

public extension UIApplication{
    var currentWindow: UIWindow?{
        if #available(iOS 13.0, *){
            if let window = connectedScenes
                .filter({  $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene})
                .compactMap({ $0 })
                .first?.windows.filter({$0.isKeyWindow}).first{
                return window
            }else if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        }else{
            if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        }
    }
}
