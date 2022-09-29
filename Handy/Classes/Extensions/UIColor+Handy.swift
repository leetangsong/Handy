//
//  UIColor+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//


import UIKit
extension UIColor: HandyCompatible{}
extension UIColor: HandyClassCompatible{ }


extension HandyExtension where Base == UIColor{
    
}


extension HandyClassExtension where Base == UIColor{
    
    public enum HandyGradientDirection {
        case level
        case vertical
        case upwardDiagonalLine
        case downDiagonalLine
    }
    
    public static func color(with hex: String,alpha: CGFloat = 1) -> UIColor{
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("0X") {
            cString = cString.replacingOccurrences(of: "0X", with: "")
        }
        if cString.hasPrefix("0x") {
            cString = cString.replacingOccurrences(of: "0x", with: "")
        }
        if cString.hasPrefix("#") {
            cString = cString.replacingOccurrences(of: "#", with: "")
        }
        if  cString.count != 6 {
            return UIColor.clear
        }

        let rStr = cString.handy[0...1]
        let gStr = cString.handy[2...3]
        let bStr = cString.handy[4...5]

        var  r:CUnsignedInt = 0,g:CUnsignedInt = 0,b:CUnsignedInt = 0
        Scanner.init(string: rStr).scanHexInt32(&r)
        Scanner.init(string: gStr).scanHexInt32(&g)
        Scanner.init(string: bStr).scanHexInt32(&b)


        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))

    }
    
    
    //两色渐变
    public static func colorGradient(with size: CGSize, cornerRadius: CGFloat = 0, direction: HandyGradientDirection = .level, startcolor: UIColor, endColor: UIColor , startPoint: CGPoint? = nil, endPoint: CGPoint? = nil)->UIColor?{
        if size == .zero {
            return nil
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.frame = CGRect.init(origin: CGPoint.zero, size: size)
        var _startPoint = CGPoint.zero
        if direction == .downDiagonalLine {
            _startPoint = CGPoint.init(x: 0, y: 1)
        }
        _startPoint = startPoint ?? _startPoint
        gradientLayer.startPoint = _startPoint
        var _endPoint = CGPoint.zero
        switch direction {
        case .level:
            _endPoint = CGPoint.init(x: 1, y: 0)
        case .vertical:
            _endPoint = CGPoint.init(x: 0, y: 1)
        case .upwardDiagonalLine:
            _endPoint = CGPoint.init(x: 1, y: 1)
        case .downDiagonalLine:
            _endPoint = CGPoint.init(x: 1, y: 0)
        }
        gradientLayer.endPoint = endPoint ?? _endPoint;
        gradientLayer.colors = [startcolor.cgColor, endColor.cgColor];
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        gradientLayer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        
        return UIColor.init(patternImage: image)
    }
    
    //多色渐变
    public static func moreColorGradient(with size: CGSize, cornerRadius: CGFloat = 0 ,startPoint: CGPoint,endPoint: CGPoint,locations: [NSNumber], colors: [AnyObject] )->UIColor?{
        if size == .zero {
            return nil
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect.init(origin: CGPoint.zero, size: size)
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint;
        gradientLayer.colors = colors;
        let gradientLocations:[NSNumber] = locations
        gradientLayer.locations = gradientLocations
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        gradientLayer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        
        return UIColor.init(patternImage: image)
    }
    ///两个颜色的平均值
    public static  func average(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        let red = fromRed + (toRed - fromRed) * percent
        let green = fromGreen + (toGreen - fromGreen) * percent
        let blue = fromBlue + (toBlue - fromBlue) * percent
        let alpha = fromAlpha + (toAlpha - fromAlpha) * percent
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
