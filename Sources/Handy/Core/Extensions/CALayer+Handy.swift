//
//  CALayer+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/11/23.
//

import UIKit

public extension HandyExtension where Base: CALayer{
    func convertedToImage(size: CGSize = .zero,
                          scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        var toSize: CGSize
        if size.equalTo(.zero) {
            toSize = base.frame.size
        }else {
            toSize = size
        }
        UIGraphicsBeginImageContextWithOptions(toSize, false, scale)
        let context = UIGraphicsGetCurrentContext()
        base.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
