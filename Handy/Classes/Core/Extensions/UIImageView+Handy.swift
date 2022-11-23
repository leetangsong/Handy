//
//  UIImageView+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/11/23.
//

import UIKit

public extension HandyExtension where Base: UIImageView{
    func image(_ image: UIImage?, animated: Bool) {
        if let image = image {
            base.image = image
            if animated {
                let transition = CATransition()
                transition.type = .fade
                transition.duration = 0.2
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                base.layer.add(transition, forKey: nil)
            }
        }
    }
    
}
