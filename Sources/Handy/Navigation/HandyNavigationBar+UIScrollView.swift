//
//  HandyNavigationBar+UIScrollView.swift
//  Handy
//
//  Created by leetangsong on 2022/10/10.
//  解决侧滑手势冲突

import UIKit


extension UIScrollView: UIGestureRecognizerDelegate{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let pan = gestureRecognizer as? UIPanGestureRecognizer, otherGestureRecognizer.view?.isKind(of: NSClassFromString("UILayoutContainerView")!) == true{
            let velocityY = pan.velocity(in: nil).y
            if velocityY != 0{
                return false
            }
            if otherGestureRecognizer.state == .began , contentOffset.x == 0{
                return true
            }
            
        }
        return false
        
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if let _ = view as? UISlider{
            isScrollEnabled = false
        }else{
            isScrollEnabled = true
        }
        return view
    }
}
