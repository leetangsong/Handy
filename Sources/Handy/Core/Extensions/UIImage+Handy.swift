//
//  UIImage+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//


import UIKit

extension UIImage: HandyCompatible{}

public extension HandyExtension where Base: UIImage {
    /// 根据设定最大值压缩图片返回二进制
    ///
    /// - Parameter maxLength: 最大值
    func compress(maxLength: Int) -> Data?{
        
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
            data = scaleToFillSize(size: CGSize.init(width: base.size.width*compression, height: base.size.height*compression))?.jpegData(compressionQuality: compression)
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
    
    func scaleSuitableSize() -> UIImage? {
        var imageSize = base.size
        while imageSize.width * imageSize.height > 3 * 1000 * 1000 {
            imageSize.width *= 0.5
            imageSize.height *= 0.5
        }
        return scaleToFillSize(size: imageSize)
    }
    
    func scaleToFillSize(size: CGSize, equalRatio: Bool = false, scale: CGFloat = 0) -> UIImage? {
        if __CGSizeEqualToSize(base.size, size) {
            return base
        }
        let scale = scale == 0 ? base.scale : scale
        let rect: CGRect
        if size.width / size.height != base.size.width / base.size.height && equalRatio {
            let scale = size.width / base.size.width
            var scaleHeight = scale * base.size.height
            var scaleWidth = size.width
            if scaleHeight < size.height {
                scaleWidth = size.height / scaleHeight * size.width
                scaleHeight = size.height
            }
            rect = CGRect(
                x: -(scaleWidth - size.height) * 0.5,
                y: -(scaleHeight - size.height) * 0.5,
                width: scaleWidth,
                height: scaleHeight
            )
        }else {
            rect = CGRect(origin: .zero, size: size)
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        base.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func scaleImage(toScale: CGFloat) -> UIImage? {
        if toScale == 1 {
            return base
        }
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: base.size.width * toScale, height: base.size.height * toScale),
            false,
            base.scale
        )
        base.draw(in: CGRect(x: 0, y: 0, width: base.size.width * toScale, height: base.size.height * toScale))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    func normalizedImage() -> UIImage? {
        if base.imageOrientation == .up {
            return base
        }
        return repaintImage()
    }
    func repaintImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        base.draw(in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func roundCropping() -> UIImage? {
        UIGraphicsBeginImageContext(base.size)
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
        path.addClip()
        base.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func cropImage(toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage? {
        if cropRect.isEmpty {
            return base
        }
        let imageViewScale = max(base.size.width / viewWidth,
                                 base.size.height / viewHeight)

        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(
            x: cropRect.origin.x * imageViewScale,
            y: cropRect.origin.y * imageViewScale,
            width: cropRect.size.width * imageViewScale,
            height: cropRect.size.height * imageViewScale
        )

        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = base.cgImage?.cropping(to: cropZone)
        else {
            return nil
        }

        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
    
}


public extension HandyClassExtension where Base: UIImage {
    
    class func image(from view: UIView, size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    class func image(for color: UIColor, size: CGSize = CGSize.init(width: 1, height: 1), radius: CGFloat = 0, rectCornerType: UIRectCorner = .allCorners, alpha: CGFloat = 1) -> UIImage{
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
    

    
    
    class func image(for named: String?, from bundlePath: String?) -> UIImage?{
        if named == nil {
            return nil
        }
        var image: UIImage?
        if var path = bundlePath {
            path += "/" + named!
            image = base.init(named: path)
        }
        if image == nil {
            image = base.init(named: named!)
        }
        return image
    }
    
    
}
