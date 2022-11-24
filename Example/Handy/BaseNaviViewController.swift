//
//  BaseNaviViewController.swift
//  Handy_Example
//
//  Created by leetangsong on 2022/10/9.
//  Copyright © 2022 CocoaPods. All rights reserved.
//
 
import UIKit
import Handy
class BaseNaviViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        handy.navigationStyle = .system
        // Do any additional setup after loading the view.
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle{
        return getStatusBarStyle()
    }

    open override var prefersStatusBarHidden: Bool{
        return topViewController?.handy.statusBarHidden ?? false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
