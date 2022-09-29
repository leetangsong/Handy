//
//  String+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//


import UIKit
extension String: HandyCompatibleValue{}
extension String: HandyClassCompatibleValue{}

extension HandyExtension where Base == String{
   
    public func size(_ font: UIFont, _ constrainedToSize: CGSize) -> CGSize{
        var resultSize = CGSize.zero
        if base.count<=0 {
            return resultSize
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let attr = NSAttributedString.init(string: base, attributes: [.font: font])
        resultSize = attr.boundingRect(with: constrainedToSize, options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size

        return resultSize
    }

    ///通过下标获取
    ///
    /// - Parameter r: [开始下标,结束下标]
    public subscript (r: ClosedRange<Int>) -> String{
        get{
            let startIndex = base.index(base.startIndex, offsetBy: r.lowerBound)
            let endIndex = base.index(base.startIndex, offsetBy: r.upperBound)
            let str = base[startIndex...endIndex]
            return String(str)
            
        }
    }
    
    ///通过下标获取
    ///
    /// - Parameter r: [下标]
    public subscript (r:Int) -> Character{
        get{
            let startIndex = base.index(base.startIndex, offsetBy: r)
            return base[startIndex]
            
        }
    }
    
}
