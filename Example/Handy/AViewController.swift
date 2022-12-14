//
//  AViewController.swift
//  TSHandyKit_Example
//
//  Created by leetangsong on 2022/9/21.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import Handy
class AViewController: UIViewController {

//    var transitioningStyle: TSTransitioningStyle = .default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        theme.naviBackgroundColor = "Global.tintColor"
        handy.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "next", style: .done, target: self, action: #selector(nextPage))
        
//        ts_transitionViews = ["button": button]
    }
    @objc func nextPage(){
        navigationController?.pushViewController(BViewController(), animated: true)
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


//extension AViewController: TSViewControllerInteractiveTransitionable{
//    
//    func enablePush() -> Bool {
//        return true
//    }
//    func interactivePushViewController() -> UIViewController? {
//        return BViewController()
//    }
//}
//
//
//
//extension AViewController: TSViewControllerTransitionable{
//
//    func transitioningStyle(operation: UINavigationController.Operation) -> TSTransitioningStyle {
//        return transitioningStyle
//    }
//    
//    func transitioningAnimater(operation: UINavigationController.Operation) -> AnimateTransitionable? {
//        return CustomAnimater()
//    }
//}
//
//class CustomAnimater: AnimateTransitionable{
//    var duration: TimeInterval = 0.3
//    
//    func transitioning(animationControllerFor operation: UINavigationController.Operation, context: UIViewControllerContextTransitioning?, fromContainerView: TSTransitionContainerView?, toContainerView: TSTransitionContainerView?, completion: (() -> Void)?) {
//        guard let fromVC = context?.viewController(forKey: .from), let toVC = context?.viewController(forKey: .to) else{
//                    return
//        }
//        context?.containerView.bringSubviewToFront(toContainerView!)
//        let toButton = toVC.ts_transitionViews["button"] as? UIView
//        let fromButton = fromVC.ts_transitionViews["button"] as? UIView
//        var endFrame = toButton?.frame ?? .zero
//        var beginFrame = fromButton?.frame ?? .zero
//        
//        toButton?.frame = beginFrame
//        UIView.animate(withDuration: duration) {
//            toButton?.frame = endFrame
//        } completion: { finished in
//            completion?()
//        }
//    }
//    
//    func animateDidBegin(animationControllerFor operation: UINavigationController.Operation, context: UIViewControllerContextTransitioning?, fromContainerView: TSTransitionContainerView?, toContainerView: TSTransitionContainerView?) {
//        guard let fromVC = context?.viewController(forKey: .from), let toVC = context?.viewController(forKey: .to) else{
//                    return
//        }
//        
////        if operation == .push{
////            let endFrame = toVC.ts_customNaviBar?.frame ?? .zero
////            toVC.ts_customNaviBar?.ts.top = -TSApp.naviBarHeight
////            
////            UIView.animate(withDuration: duration) {
////                toVC.ts_customNaviBar?.frame = endFrame
////            }
////            
////        }
//        
//    }
//}
