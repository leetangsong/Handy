//
//  ViewController.swift
//  TSHandyKit
//
//  Created by litangsong on 05/19/2022.
//  Copyright (c) 2022 litangsong. All rights reserved.
//

import UIKit
//import TSHandyKit

class NaviViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var naviStyle: UILabel!
    @IBOutlet weak var barAlphaLabel: UILabel!
    
    open override var prefersStatusBarHidden: Bool{
        return true
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        automaticallyAdjustsScrollViewInsets = false
//        ts.naviBackgroundColor = UIColor.ts.color(with: "#FF7E79")
//        ts.naviTintColor = .red
//        ts.naviTitleColor = .red
//        ts.statusBarHidden = true
//        ts.naviBarHidden = true
//        scrollView.contentInset = UIEdgeInsets.init(top: TSApp.naviBarHeight, left: 0, bottom: TSApp.safeAreaBottom, right: 0)
//        ts.title = "\((navigationController?.viewControllers.count ?? 0))"
        
    }
   
//    @objc func pop(){
//        navigationController?.popViewController(animated: true)
//    }
//    @IBAction func naviStyleAction(_ sender: UIButton) {
//        self.ts.navigationController?.navigationStyle = TSNavigationStyle.init(rawValue: sender.tag) ?? .system
//        naviStyle.text = "导航栏样式 \(sender.currentTitle ?? "")"
//    }
//    func ts_customBackItem(_ target: Any?, action: Selector) -> UIBarButtonItem {
//        return UIBarButtonItem.init(title: "返回", style: .done, target: target, action: action)
//    }
//    @IBAction func shadowColor(_ sender: UIButton) {
//        guard let color = sender.backgroundColor else { return }
//        ts.naviShadowColor = color
//    }
//    @IBAction func barTranslucent(_ sender: UISwitch) {
//        ts.naviIsTranslucent = sender.isOn
//        
//        scrollView.contentInset = sender.isOn ? UIEdgeInsets.init(top: TSApp.naviBarHeight, left: 0, bottom: TSApp.safeAreaBottom, right: 0) : .zero
//    }
//    
//    @IBAction func barHidden(_ sender: UISwitch) {
//        navigationController?.setNavigationBarHidden(sender.isOn, animated: true)
//    }
//    @IBAction func barColorBtnClicked(_ sender: UIButton) {
//        guard let color = sender.backgroundColor else { return }
//        ts.naviBackgroundColor = color
//    }
////
//    @IBAction func barImageSwitchChanged(_ sender: UISwitch) {
//        if sender.isOn {
//            let image = UIImage(named: "sunset")
//            ts.naviBackgroundImage = image
//        } else {
//            ts.naviBackgroundImage = nil
//        }
//    }
////
//    @IBAction func blackBarStyleSwitchChanged(_ sender: UISwitch) {
//        ts.statusBarStyle  = sender.isOn ? .dark : .lightContent
//      
//    }
//    
//    @IBAction func shadowHiddenSwitchChanged(_ sender: UISwitch) {
//        ts.naviShadowHidden = sender.isOn
//    }
//
//    @IBAction func statusBarHiddenSwitchChanged(_ sender: UISwitch) {
//
//        
//        ts.setStatusBarHidden(sender.isOn, animate: true)
//    }
//    
//    @IBAction func barAlphaSliderChanged(_ sender: UISlider) {
//        barAlphaLabel.text = String(format: "%.2f", sender.value)
//        ts.naviBarAlpha = CGFloat(sender.value)
//    }
//
//    @IBAction func tintColorBtnClicked(_ sender: UIButton) {
//        guard let color = sender.backgroundColor else { return }
//        ts.naviTintColor = color
//    }
//
//    @IBAction func titleColorBtnClicked(_ sender: UIButton) {
//        guard let color = sender.backgroundColor else { return }
//        ts.naviTitleColor = color
//    }
////
//    @IBAction func pushToNext(_ sender: Any) {
//        guard let demoVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") else { return }
//        navigationController?.ts.pushViewController(demoVC, animated: true, complete: { finished in
//            print("完成了")
//        })
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        scrollView.frame = view.bounds
//    }
//    
//    @IBAction func dismiss(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    deinit {
//        print("销毁\(self)")
//    }
    
}


//
//extension ViewController: TSViewControllerTransitionable{
//
//    func transitioningStyle(operation: UINavigationController.Operation) -> TSTransitioningStyle {
//        return .transformScale
//    }
//
//
//}
