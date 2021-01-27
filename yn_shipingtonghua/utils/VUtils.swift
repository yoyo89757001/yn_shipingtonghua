//
//  VUtils.swift
//  yn_shipingtonghua
//
//  Created by 陈军 on 2021/1/26.
//

import Foundation
import UIKit


class VUtils {
    
   static func Label(view:UIView,text:String,color:String,size:Int) -> UILabel{
        let lab = UILabel()
        lab.text=text
        lab.font=UIFont.systemFont(ofSize: CGFloat(size))
        lab.textColor=UIColor.init(hexString: color)
        view.addSubview(lab)
        return lab
    }
    
    static func ImageView(view:UIView,name:String) -> UIImageView{
        let imag = UIImageView()
        imag.image=UIImage.init(named: name)
        view.addSubview(imag)
        return imag
     }
    
    static func Button(view:UIView,name:String,top:CGFloat,left:CGFloat,bottom:CGFloat,right:CGFloat) -> UIButton{
        let butt = UIButton()
        butt.setImage(UIImage.init(named: name), for: UIControl.State.normal)
        butt.imageEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right) //内边距
        view.addSubview(butt)
        return butt
     }
    
    
    
    
}
