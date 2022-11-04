//
//  ThemeViewController.swift
//  Handy_Example
//
//  Created by leetangsong on 2022/10/25.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import Handy
class ThemeViewController: UIViewController {

    @IBOutlet weak var systemSwitch: UISwitch!
    
    @IBOutlet weak var themeButton: UIButton!
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var themeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.handy.navigationStyle = .system
        handy.title = "主题"
        view.theme.backgroundColor = "Global.backgroundColor"
        themeImageView.theme.image = "ThemeImage.iconImage"
        themeLabel.theme.font = "Global.textFont"
        themeLabel.theme.textColor = "Global.textColor"

//        theme.naviBackgroundColor = "Global.barTintColor"
//        theme.naviTitleColor = "Global.barTextColor"
        theme.naviBarStyle = "NaviBarStyle"
//        theme.naviTintColor = "Global.tintColor"
        
        themeButton.theme.setTitleColor("ChangeTheme.buttonTitleColorNormal", forState: .normal)
        themeButton.theme.setTitleColor("ChangeTheme.buttonTitleColorHighlighted", forState: .highlighted)
        themeButton.theme.backgroundColor = "ChangeTheme.buttonBackgroundColor"
        
        
        handy.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "next", style: .done, target: self, action: #selector(nextPage))
        if #available(iOS 13.0, *) {
            systemSwitch.isOn = ThemeManager.isFollowSystemTheme
        }
        // Do any additional setup after loading the view.
    }
    @objc func nextPage(){
        navigationController?.pushViewController(AViewController(), animated: true)
    }
   
    @IBAction func followSystem(_ sender: UISwitch) {
        if #available(iOS 13.0, *) {
            ThemeManager.isFollowSystemTheme = sender.isOn
        }
    }
    @IBAction func selectTheme(_ sender: UIButton) {
        
        if #available(iOS 13.0, *), ThemeManager.isFollowSystemTheme {
            return
        }
        
        if sender.tag == 2{
            guard MyThemes.isBlueThemeExist() else {

                let title   = "Not Downloaded"
                let message = "Download the theme right now?"
                
                let alert = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)

                alert.addAction(UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: nil)
                )
                alert.addAction(UIAlertAction(
                    title: "Sure",
                    style: .default,
                    handler: { [unowned self] _ in
                        self.downloadStart()
                    })
                )
                
                present(alert, animated: true, completion: nil)
                return
            }
            
            MyThemes.switchTo(.blue)
        }else{
            MyThemes.switchTo(MyThemes(rawValue: sender.tag)!)
        }
        
    }
    @IBAction func changTheme(_ sender: Any) {
        if #available(iOS 13.0, *), ThemeManager.isFollowSystemTheme {
            return
        }
        MyThemes.switchToNext()
    }
    
    fileprivate func downloadStart() {
        let HUD = navigationController!.showHUD("Download Theme...")
        
        MyThemes.downloadBlueTask() { isSuccess in
            HUD.label.text = isSuccess ? "Successful!" : "Failure!"
            HUD.mode = .text
            HUD.hide(animated: true, afterDelay: 1)
            
            if isSuccess {
                MyThemes.switchTo(.blue)
            }
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    deinit {
        print("销毁\(self)")
    }
}
