//
//  Utils.swift
//  tongyaozhineng1
//
//  Created by mac on 2020/10/17.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    var nicheng: DefaultsKey<String?> { .init("nicheng",defaultValue: "") }
    var username: DefaultsKey<String?> { .init("username",defaultValue: "") }
    var password: DefaultsKey<String?> { .init("password",defaultValue: "") }
    var topbarHeight: DefaultsKey<Int> { .init("topbarHeight",defaultValue:10)}
    var launchCount: DefaultsKey<Int> { .init("launchCount", defaultValue: 0) }
    var checkbox: DefaultsKey<Bool> { .init("checkbox", defaultValue: true) }
    var isLogin: DefaultsKey<Bool> { .init("isLogin", defaultValue: false) }
    
}
class SizeHelper {
    
    class func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
   
    
}
extension UIView {
    
    /// 设置阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移量
    ///   - opacity: 阴影透明度
    ///   - radius: 阴影半径
    func addShadow(color: UIColor, offset:CGSize, opacity:Float, radius:CGFloat) {
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}

extension UIColor {
     
    // Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
//        if hexString.hasPrefix("#") {
//            scanner.scanLocation = 1
//        }
         
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
     
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
         
        let multiplier = CGFloat(255.999999)
         
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
         
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}


//该方法是对 stackoverflow 方案的改良版，不需要提前给定图片大小
//通过设置内边距的大小，就可以自动适应、调整
//设置上更为方便，同时能自动兼容各种图像

extension UIImageView {
    
    /// 使用前请先设置 UIImageView.contentMode = .center
    func padding(_ all: CGFloat) {
        guard let image = self.image else {
            print("this image is nil when padding")
            return
        }
        let originSize = self.frame.size
        var scaledToSize: CGSize = .zero
        if image.size.width > image.size.height {
            let radio = image.size.height / image.size.width
            scaledToSize = CGSize(width: originSize.width - all * 2, height: (originSize.height - all * 2) * radio)
        } else {
            let radio = image.size.width / image.size.height
            scaledToSize = CGSize(width: (originSize.width - all * 2) * radio, height: originSize.height - all * 2)
        }
        UIGraphicsBeginImageContextWithOptions(scaledToSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledToSize.width, height: scaledToSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = newImage
    }
    
}

extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
     
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}

extension UIView {

    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

