//
//  UIColor+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//


import UIKit
public enum UIColorInputError : Error {
    case missingHashMarkAsPrefix,
    unableToScanHexValue,
    mismatchedHexStringLength
}


extension UIColor: HandyCompatible{
    open override var description: String {
        return handy.hexString(true)
    }
}
extension UIColor: HandyClassCompatible{ }


extension HandyExtension where Base == UIColor{
    public func hexString(_ includeAlpha: Bool) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        base.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if (includeAlpha) {
            return String(format: "#%02X%02X%02X%02X", Int(round(r * 255)), Int(round(g * 255)), Int(round(b * 255)), Int(round(a * 255)))
        } else {
            return String(format: "#%02X%02X%02X", Int(round(r * 255)), Int(round(g * 255)), Int(round(b * 255)))
        }
    }
}


extension HandyClassExtension where Base == UIColor{
    
    public enum HandyGradientDirection {
        case level
        case vertical
        case upwardDiagonalLine
        case downDiagonalLine
    }
    /// #RGB
    public static func color(hex3: UInt16, alpha: CGFloat = 1) -> UIColor {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue    = CGFloat( hex3 & 0x00F      ) / divisor

        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 0xRGBA
    public static func color(hex4: UInt16) -> UIColor {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green   = CGFloat((hex4 & 0x0F00) >>  8) / divisor
        let blue    = CGFloat((hex4 & 0x00F0) >>  4) / divisor
        let alpha   = CGFloat( hex4 & 0x000F       ) / divisor

        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    /// 0xRRGGBB
    public static func color(hex6: UInt32, alpha: CGFloat = 1) -> UIColor {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor

        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    ///  #RRGGBBAA
    public static func color(hex8: UInt32) -> UIColor {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex8 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex8 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex8 & 0x0000FF       ) / divisor
        let alpha   = CGFloat( hex8 & 0x000000FF       ) / divisor
        
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    
    public static func color(rgba_throws: String) throws -> UIColor{
       
        var hexString = rgba_throws
        
        if hexString.hasPrefix("0X") {
            hexString = hexString.replacingOccurrences(of: "0X", with: "")
        }else if hexString.hasPrefix("0x") {
            hexString = hexString.replacingOccurrences(of: "0x", with: "")
        }else if hexString.hasPrefix("#") {
            hexString = hexString.replacingOccurrences(of: "#", with: "")
        }
        if hexString.count == rgba_throws.count{
            throw UIColorInputError.missingHashMarkAsPrefix
        }
        var hexValue:  UInt32 = 0
        guard Scanner(string: hexString).scanHexInt32(&hexValue) else {
            throw UIColorInputError.unableToScanHexValue
        }

        switch (hexString.count) {
        case 3:
            return color(hex3: UInt16(hexValue))
        case 4:
            return color(hex4: UInt16(hexValue))
        case 6:
            return color(hex6: hexValue)
        case 8:
            return color(hex8: hexValue)
        default:
            throw UIColorInputError.mismatchedHexStringLength
        }

    }
    
    public static func color(rgba: String, defaultColor: UIColor = UIColor.clear) -> UIColor{
        guard let color = try? color(rgba_throws: rgba) else {
            return defaultColor
        }
        return color
        
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
