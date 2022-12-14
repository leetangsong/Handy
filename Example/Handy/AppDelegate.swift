//
//  AppDelegate.swift
//  Handy
//
//  Created by leetangsong on 09/29/2022.
//  Copyright (c) 2022 leetangsong. All rights reserved.
//

import UIKit
import Handy
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.runOnce()
        
        if #available(iOS 13.0, *) {
            ThemeManager.setTheme(jsonName: "Red"  , path: .mainBundle)
            ThemeManager.followSystemThemeAction = { style in
                ThemeManager.setTheme(jsonName: style == .light ? "Red" : "Night" , path: .mainBundle)
            }
        }else{
            ThemeManager.setTheme(jsonName: "Red", path: .mainBundle)
        }
        
//        let navigationBar = UINavigationBar.appearance()
//        navigationBar.theme.barTintColor = "Global.barTintColor"
//        navigationBar.theme.tintColor = "Global.tintColor"
//        navigationBar.theme.titleTextAttributes = ThemeStringAttributesPicker(keyPath: "Global.barTextColor") { value -> [NSAttributedString.Key : AnyObject]? in
//            guard let rgba = value as? String else {
//                return nil
//            }
//            
//            let color = UIColor.handy.color(rgba: rgba)
//            let shadow = NSShadow(); shadow.shadowOffset = CGSize.zero
//            let titleTextAttributes = [
//                NSAttributedString.Key.foregroundColor: color,
//                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
//                NSAttributedString.Key.shadow: shadow
//            ]
//            
//            return titleTextAttributes
//        }
        
        
//        window = UIWindow.init(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
//        
//        let vc = storyboard.instantiateViewController(withIdentifier: "mainVC")
//        
//        window?.rootViewController = UINavigationController.init(rootViewController: vc)
//        window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

}

