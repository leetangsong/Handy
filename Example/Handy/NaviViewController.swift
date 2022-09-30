//
//  ViewController.swift
//  TSHandyKit
//
//  Created by litangsong on 05/19/2022.
//  Copyright (c) 2022 litangsong. All rights reserved.
//

import UIKit
import Handy

class NaviViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var naviStyle: UILabel!
    @IBOutlet weak var barAlphaLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        automaticallyAdjustsScrollViewInsets = false
        handy.naviBackgroundColor = UIColor.handy.color(with: "#FF7E79")
        handy.naviTintColor = .red
        handy.naviTitleColor = .red
        scrollView.contentInset = UIEdgeInsets.init(top: HandyApp.naviBarHeight, left: 0, bottom: HandyApp.safeAreaBottom, right: 0)
        handy.title = "\((navigationController?.viewControllers.count ?? 0))"
        
    }
   
    @objc func pop(){
        navigationController?.popViewController(animated: true)
    }
    @IBAction func naviStyleAction(_ sender: UIButton) {
        navigationController?.handy.navigationStyle = HandyNavigationStyle.init(rawValue: sender.tag) ?? .system
        naviStyle.text = "导航栏样式 \(sender.currentTitle ?? "")"
    }
    func ts_customBackItem(_ target: Any?, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem.init(title: "返回", style: .done, target: target, action: action)
    }
    @IBAction func shadowColor(_ sender: UIButton) {
        guard let color = sender.backgroundColor else { return }
        handy.naviShadowColor = color
    }
    @IBAction func barTranslucent(_ sender: UISwitch) {
        handy.naviIsTranslucent = sender.isOn
        
        scrollView.contentInset = sender.isOn ? UIEdgeInsets.init(top: HandyApp.naviBarHeight, left: 0, bottom: HandyApp.safeAreaBottom, right: 0) : .zero
    }
    
    @IBAction func barHidden(_ sender: UISwitch) {
        navigationController?.setNavigationBarHidden(sender.isOn, animated: true)
    }
    @IBAction func barColorBtnClicked(_ sender: UIButton) {
        guard let color = sender.backgroundColor else { return }
        handy.naviBackgroundColor = color
    }
//
    @IBAction func barImageSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            let image = UIImage(named: "sunset")
            handy.naviBackgroundImage = image
        } else {
            handy.naviBackgroundImage = nil
        }
    }
//
    @IBAction func blackBarStyleSwitchChanged(_ sender: UISwitch) {
        handy.statusBarStyle  = sender.isOn ? .dark : .lightContent
      
    }
    
    @IBAction func shadowHiddenSwitchChanged(_ sender: UISwitch) {
        handy.naviShadowHidden = sender.isOn
    }

    @IBAction func statusBarHiddenSwitchChanged(_ sender: UISwitch) {

        
        handy.setStatusBarHidden(sender.isOn, animate: true)
    }
    
    @IBAction func barAlphaSliderChanged(_ sender: UISlider) {
        barAlphaLabel.text = String(format: "%.2f", sender.value)
        handy.naviBarAlpha = CGFloat(sender.value)
    }

    @IBAction func tintColorBtnClicked(_ sender: UIButton) {
        guard let color = sender.backgroundColor else { return }
        handy.naviTintColor = color
    }

    @IBAction func titleColorBtnClicked(_ sender: UIButton) {
        guard let color = sender.backgroundColor else { return }
        handy.naviTitleColor = color
    }
//
    @IBAction func pushToNext(_ sender: Any) {
        guard let demoVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") else { return }
        navigationController?.handy.pushViewController(demoVC, animated: true, complete: { finished in
            print("完成了")
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    deinit {
        print("销毁\(self)")
    }
    
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
