//
//  CollectionViewCell.swift
//  tongyaozhineng1
//
//  Created by mac on 2020/10/22.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell
{
    let kaishi=UIButton()
    var imageView: UIImageView!
    var uiview: UIView!
    var topview = UIView()
    let name = PaddingLabel()
    let times = PaddingLabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        uiview = UIView();
        uiview.backgroundColor =  UIColor.init(hexString: "ffffff")
        imageView = UIImageView()
       
        //UIColor(red: 0x69/255, green: 0x69/255, blue: 0x69/255, alpha: 1.0)
        
     
        kaishi.setTitle("探视", for: UIControl.State.normal)
        kaishi.setTitleColor(UIColor.init(hexString: "ffffff"), for: .normal)
        kaishi.backgroundColor=UIColor.init(hexString: "E6481D")
        topview.backgroundColor=UIColor(red: 0x00/255, green: 0x00/255, blue: 0x00/255, alpha: 0.4)
        name.textColor=UIColor.white
        name.font=UIFont.systemFont(ofSize: 15)
        name.backgroundColor=UIColor(red: 0xE6/255, green: 0x48/255, blue: 0x1D/255, alpha: 0.4)
        name.textInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6) //内边距
        
        times.textColor=UIColor.white
        times.font=UIFont.systemFont(ofSize: 15)
        times.textAlignment = .center
        times.backgroundColor=UIColor(red: 0x00/255, green: 0x00/255, blue: 0x00/255, alpha: 0.3)
        times.textInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6) //内边距
        times.lineBreakMode = NSLineBreakMode.byWordWrapping //多行
        times.numberOfLines = 0 //多行
        
        uiview.addSubview(imageView)
        uiview.addSubview(kaishi)
        uiview.addSubview(topview)
        topview.addSubview(name)
        topview.addSubview(times)
        
        addSubview(uiview)
        
            uiview.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(10)
                    make.left.equalToSuperview().offset(10)
                    make.right.equalToSuperview().offset(-10)
                    make.bottom.equalToSuperview().offset(-2)
               }
        
        imageView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview()
                    make.height.equalTo(180)
                }
        topview.snp.makeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview()
                    make.height.equalTo(180)
                }
        
        kaishi.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-18)
                make.centerX.equalToSuperview()
                make.width.equalTo(130)
                make.height.equalTo(44)
            }
        
        name.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
            }
               
        times.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                
            }
        
        
       // 设置边框
       // uiview.layer.borderWidth = 1
       // uiview.layer.borderColor = UIColor.init(hexString: "ffffff").cgColor

        // 设置阴影
        uiview.layer.masksToBounds = false
        uiview.layer.shadowColor=UIColor.gray.cgColor
        uiview.layer.shadowOpacity = 0.3   //不透明度
        uiview.layer.shadowOffset = CGSize(width: 0, height: 0)   // 设置阴影的偏移量
        uiview.layer.shadowRadius = 5        //设置阴影所照射的范围
        
        
        // 设置阴影
//        titleLabel.layer.masksToBounds = false
//        titleLabel.layer.shadowColor=UIColor.gray.cgColor
//        titleLabel.layer.shadowOpacity = 0.3   //不透明度
//        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)   // 设置阴影的偏移量
//        titleLabel.layer.shadowRadius = 5        //设置阴影所照射的范围
        kaishi.layer.cornerRadius = 8
        kaishi.clipsToBounds = true
        // 设置圆角
        uiview.layer.cornerRadius = 10
       // uiview.clipsToBounds = true  //阴影要把这个注释
        
    
        //imageView.clipsToBounds = true
//        imageView.corner(byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: 10)
        
        // 圆角大小
        let radius: CGFloat = 10;
        // 圆角位置
        let corner: UIRectCorner = [.topLeft, .topRight]
        //frame可以先计算完成  避免圆角拉伸
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-32, height: 180)
        let path: UIBezierPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = rect;
        maskLayer.path = path.cgPath
        imageView.layer.mask = maskLayer;
        let maskLayer2: CAShapeLayer = CAShapeLayer()
        maskLayer2.frame = rect;
        maskLayer2.path = path.cgPath
        topview.layer.mask = maskLayer2;
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
