//
//  UIImage+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//


import UIKit

extension UIImage: HandyCompatible{}

extension HandyExtension where Base == UIImage {
    /// 根据设定最大值压缩图片返回二进制
    ///
    /// - Parameter maxLength: 最大值
    public func compress(maxLength: Int) -> Data?{
        
        var compression: CGFloat = 1
        var data = base.jpegData(compressionQuality: compression)
        if data == nil {
            return nil
        }
        guard data!.count > maxLength else { return data }
        var max: CGFloat = 1
        var min: CGFloat = 0
        while (data!.count > maxLength) {
            compression = (max + min) / 2
            data = toNewWidth(base.size.width*compression).jpegData(compressionQuality: compression)
            if data == nil {
                return nil
            }
            if CGFloat(data!.count)<CGFloat(maxLength)*0.9 {
                min = compression
            }else if data!.count > maxLength{
                max = compression
            }
        }
        return data
    }
    
    public func toNewWidth(_ newWidth: CGFloat) -> UIImage {
        
        let imageWidth = base.size.width
        let imageHeight = base.size.height
        let width = newWidth
        let height = imageHeight/(imageWidth/width)
        let widthScale = imageWidth/width
        let heightScale = imageHeight/height
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: width, height: height), false, UIScreen.main.scale)
        if widthScale > heightScale {
            base.draw(in: CGRect.init(x: 0, y: 0, width: imageWidth/heightScale, height: height))
        }else{
            base.draw(in: CGRect.init(x: 0, y: 0, width: width, height: imageHeight/widthScale))
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return newImage;
    }
}


extension HandyClassExtension where Base == UIImage {
    
    public static func image(from view: UIView, size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    public static func image(with size: CGSize, radius: CGFloat = 0, rectCornerType: UIRectCorner = .allCorners, alpha: CGFloat = 1, color: UIColor) -> UIImage{
        let targetRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        
        if radius == 0 {
            context?.fill(targetRect)
        }else {
            let path = UIBezierPath.init(roundedRect: targetRect, byRoundingCorners: rectCornerType, cornerRadii: CGSize.init(width: radius, height: radius))

            context?.addPath(path.cgPath)
            
            context?.drawPath(using: .fill)
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return finalImage
    }
    
    public static func image(with color:UIColor) -> UIImage {
        return image(with: CGSize.init(width: 1, height: 1), color: color)
    }
    
    
    public static func image(with name: String, from bundlePath: String?) -> UIImage?{
        if name.count == 0 {
            return nil
        }
        if bundlePath == nil {
            return UIImage.init(named: name)
        }
        let scale = Int(UIScreen.main.scale)
        let _name = "\(name)\(scale>1 ? "@\(scale)x":"")"
        let bundle = Bundle.init(path: bundlePath!)
        
        var image: UIImage?
        if let path = bundle?.path(forResource: _name, ofType: ".png") {
            image = UIImage.init(contentsOfFile: path)
        }
        
        if image == nil, let path = bundle?.path(forResource: "\(name)@2x", ofType: ".png")  {
            image = UIImage.init(contentsOfFile: path)
        }
        if image == nil, let path = bundle?.path(forResource: "\(name)", ofType: ".png")  {
            image = UIImage.init(contentsOfFile: path)
        }
        
        if image == nil {
            image = UIImage.init(named: name)
        }
        return image
    }
}
