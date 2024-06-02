//
//  AppDelegate.swift
//  Feelin
//
//  Created by Derrick kim on 2/19/24.
//

import KakaoSDKCommon
import SharedUtil
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
         _ application: UIApplication,
         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
         if let kakaoNativeAppKey = Bundle.main.kakaoNativeAppKey {
             KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
             return true
         } else {
             return false
         }
     }

     func application(
         _ application: UIApplication,
         configurationForConnecting connectingSceneSession: UISceneSession,
         options: UIScene.ConnectionOptions
     ) -> UISceneConfiguration {
         return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
     }
}
