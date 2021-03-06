//
//  Logging.swift
//  yn_shipingtonghua
//
//  Created by 陈军 on 2021/1/25.
//

import Foundation
import UIKit
import SwiftyUserDefaults
import SnapKit
import Alamofire
import QMUIKit


//登录界面
class Logging: UIViewController {
    let topbox = UIView()
    let widthS = UIScreen.main.bounds.size.width
    let heightS = UIScreen.main.bounds.size.height
    let et1 = UITextField()
    let et2 = UITextField()
    let denglu = UIButton()
    var qmuiTip : QMUITips? =  nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(maxTouch))
        view.addGestureRecognizer(tap)
        
        view.backgroundColor=UIColor.init(hexString: "f8f9fb")
        print(Defaults.topbarHeight,"状态栏高度")
        view.addSubview(topbox)
        view.addSubview(et1)
        view.addSubview(et2)
        view.addSubview(denglu)
        
        let logo = VUtils.ImageView(view: topbox, name: "a22")
        let tv = VUtils.Label(view: topbox, text: "颐年养老", color: "333333", size: 22)
        let tv1 = VUtils.Label(view: view, text: "手机号", color: "333333", size: 16)
        let tv2 = VUtils.Label(view: view, text: "密码", color: "333333", size: 16)
        
        et1.borderStyle = .roundedRect
        et1.placeholder="小程序预约手机号"
        et1.adjustsFontSizeToFitWidth=true//当文字超出文本框宽度时，自动调整文字大小
        et1.minimumFontSize = 12 //最小可缩小的字号
        et1.textColor=UIColor.init(hexString: "333333")
        et1.font=UIFont.systemFont(ofSize: 15)
        et1.keyboardType = UIKeyboardType.numberPad
        
        et2.borderStyle = .roundedRect
        et2.placeholder="默认密码123456"
        et2.adjustsFontSizeToFitWidth=true//当文字超出文本框宽度时，自动调整文字大小
        et2.minimumFontSize = 12 //最小可缩小的字号
        et2.textColor=UIColor.init(hexString: "333333")
        et2.font=UIFont.systemFont(ofSize: 15)
        et2.isSecureTextEntry = true//输入内容会显示成小黑点
        
        denglu.setTitle("登 录", for: .normal)
        denglu.setTitleColor(UIColor.white, for: .normal)
        denglu.backgroundColor=UIColor.init(hexString: "E6481D")
        denglu.setTitleColor(UIColor.gray, for: .highlighted)
        denglu.layer.cornerRadius = 6
        denglu.layer.masksToBounds = true
        denglu.addTarget(self, action: #selector(dengluTouch), for: UIControl.Event.touchUpInside)
        
       
        topbox.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(CGFloat(Defaults.topbarHeight) + widthS*0.12)
            make.centerX.equalToSuperview()
        }
        logo.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(widthS*0.20)
            make.height.equalTo(widthS*0.20)
        }
        tv.snp.makeConstraints { (make) in
            make.centerY.equalTo(logo.snp.centerY)
            make.left.equalTo(logo.snp.right).offset(10)
            make.right.equalToSuperview()
        }
        tv1.snp.makeConstraints { (make) in
            make.top.equalTo(topbox.snp.bottom).offset(60)
            make.left.equalToSuperview().offset(widthS*0.2)
            
        }
        et1.snp.makeConstraints { (make) in
            make.top.equalTo(tv1.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(widthS*0.2)
            make.right.equalToSuperview().offset(-widthS*0.2)
            make.height.equalTo(44)
        }
        tv2.snp.makeConstraints { (make) in
            make.top.equalTo(et1.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(widthS*0.2)
            
        }
        et2.snp.makeConstraints { (make) in
            make.top.equalTo(tv2.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(widthS*0.2)
            make.right.equalToSuperview().offset(-widthS*0.2)
            make.height.equalTo(44)
        }
        denglu.snp.makeConstraints { (make) in
            make.top.equalTo(et2.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(widthS*0.2)
            make.right.equalToSuperview().offset(-widthS*0.2)
            make.height.equalTo(44)
        }
        
        if Defaults.phone != "" {
            et1.text=Defaults.phone
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
               // 隐藏导航栏 true 有动画
           self.navigationController?.setNavigationBarHidden(true, animated: false)
        
       }
    
    func loging_link(){
        qmuiTip = QMUITips.showLoading("登录中...", in: self.view)
        struct Login: Encodable {
            let phone: String
            let password: String
            let deviceType: String //设备类型 2
            let deviceId: String //唯一id
            let deviceBrand: String
            let appBuild: String
        }
        let login = Login(phone: et1.text!,password: et2.text!, deviceType: "2",deviceId: "",deviceBrand: "",appBuild: "")
             //JSONParameterEncoder.default //URLEncodedFormParameterEncoder.default
             AF.request(URL+"/api/nurse/familyLogin",
               method: .post,
               parameters: login,
               encoder: JSONParameterEncoder.default).responseString { response in
                print("返回值",response.value!)
                struct ResultModel :Codable{
                    var nurseName : String?
                    var headImg : String?
                    var nurseCode : String?
                    var token : String?
                }
                struct myDate : Codable{
                    var success : Bool?
                    var result :ResultModel?
                    var errorMsg : String?
                }
                do{
                    let handyModel = try JSONDecoder().decode(myDate.self, from: response.data ?? Data())
                    print("username:" , handyModel.success ?? false)
                    // print("password:",handyModel.errorMsg)
                     //Defaults.password = ""
                     DispatchQueue.main.async {
                         self.qmuiTip?.hide(animated: true)
                        if handyModel.success ?? false {
                            Defaults.password = self.et2.text
                            Defaults.phone = self.et1.text
                            Defaults.token = handyModel.result?.token
                            Defaults.headUrl = handyModel.result?.headImg
                            Defaults.username = handyModel.result?.nurseName
                            self.navigationController?.popViewController(animated: true)

                         }else{
                             QMUITips.showInfo(handyModel.errorMsg, in: self.view)
                         }
                             
                             
                    }
                }catch{
                    print(error,"错误")
                }
             
               
        }
    }
 
    
    @objc
    func dengluTouch() {
        if et1.text=="" || et2.text==""{
            QMUITips.showInfo("请输入完整信息", in: self.view)
            return
        }
        loging_link()
    }
    
    @objc
    func maxTouch()  {
         et1.resignFirstResponder()
         et2.resignFirstResponder()
    }

}
