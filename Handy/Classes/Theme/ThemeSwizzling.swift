//
//  ThemeSwizzling.swift
//  Handy
//
//  Created by leetangsong on 2022/11/22.
//

import UIKit

class ThemeSwizzling: NSObject, HandySwizzling {
    static func awake() {
        addSwizzlingMethod(cls: UIViewController.self, sel: #selector(UIViewController.viewControllerThemeSwizzling))
    }
}
