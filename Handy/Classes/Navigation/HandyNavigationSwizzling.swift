//
//  HandyNavigationSwizzling.swift
//  Handy
//
//  Created by leetangsong on 2022/11/22.
//

import UIKit

class HandyNavigationSwizzling: NSObject, HandySwizzling{
    static func awake() {
        addSwizzlingMethod(cls: UIViewController.self, sel: #selector(UIViewController.viewControllerSwizzling))
        addSwizzlingMethod(cls: UINavigationController.self, sel: #selector(UINavigationController.navigationSwizzling))
    }
    
}
