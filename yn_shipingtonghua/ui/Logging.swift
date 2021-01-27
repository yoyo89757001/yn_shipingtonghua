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

//登录界面
class Logging: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.init(hexString: "ffffff")
        print(Defaults.topbarHeight,"状态栏高度")
        
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
           self.navigationController?.setNavigationBarHidden(true, animated: false)
           super.viewWillAppear(animated)
               // 隐藏导航栏 true 有动画
       
       }
    
    

}
