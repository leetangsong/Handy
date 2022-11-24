//
//  UILabel+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/11/23.
//

import UIKit

public extension HandyExtension where Base: UILabel{
    var textHeight: CGFloat {
        base.text?.handy.height(ofFont: base.font, maxWidth: width > 0 ? width : CGFloat(MAXFLOAT)) ?? 0
    }
    var textWidth: CGFloat {
        base.text?.handy.width(ofFont: base.font, maxHeight: height > 0 ? height : CGFloat(MAXFLOAT)) ?? 0
    }
    
}
