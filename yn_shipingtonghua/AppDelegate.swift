//
//  AppDelegate.swift
//  yn_shipingtonghua
//
//  Created by 陈军 on 2021/1/25.
//

import UIKit
import SwiftyUserDefaults

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let systemVersion = UIDevice.init().systemVersion;
        print(systemVersion,"当前设备版本")
        if ((Double.init(systemVersion) ?? 10) >= 13.0) {
                    print("systemVersion","大于13")
            Defaults.topbarHeight = Int(window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 44)
        }else{
          
            Defaults.topbarHeight = Int(UIApplication.shared.statusBarFrame.height)
            let screen = UIScreen.main.bounds        //获得设备尺寸
            self.window = UIWindow.init(frame: screen)//给“输出窗口“实例化并设置frame
            let viewController = ViewController()//实例化一个ViewController
            let navigationController = UINavigationController(rootViewController: viewController)  //为ViewController设置一个导航栏
            self.window?.rootViewController = navigationController//将“输出窗口”的根视图设置为导航栏
            self.window?.makeKeyAndVisible()
            
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

