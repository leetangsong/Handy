//
//  HandyTransition+UINavigationControllerDelegate.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//

import UIKit

extension HandyTransition: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//      if let previousNavigationDelegate = navigationController.previousNavigationDelegate {
//        previousNavigationDelegate.navigationController?(navigationController, willShow: viewController, animated: animated)
//      }
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//      if let previousNavigationDelegate = navigationController.previousNavigationDelegate {
//        previousNavigationDelegate.navigationController?(navigationController, didShow: viewController, animated: animated)
//      }
    }
//
//    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//      guard !isTransitioning else { return nil }
//      self.state = .notified
//      self.isPresenting = operation == .push
//      self.fromViewController = fromViewController ?? fromVC
//      self.toViewController = toViewController ?? toVC
//      self.inNavigationController = true
//      return self
//    }
//
//    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//      return interactiveTransitioning
//    }
}
