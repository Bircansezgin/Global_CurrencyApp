//
//  AppDelegate.swift
//  DovizConvert
//
//  Created by Bircan Sezgin on 25.05.2023.
//

import UIKit
import GoogleMobileAds
import OneSignal
import AppTrackingTransparency
import AdSupport
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        FirebaseApp.configure()
        
        
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
        
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("ee20923b-3358-41ba-b8e9-f88d007ca024")
 
        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
          print("User accepted notifications: \(accepted)")
        })
        
         OneSignal.setExternalUserId("ee20923b-3358-41ba-b8e9-f88d007ca024")
        return true
    }
    
    func requestAppTrackingPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Kullanıcı izni verdi, reklam kimliğini almak için kullanabilirsiniz.
                    let adIdentifier = ASIdentifierManager.shared().advertisingIdentifier
                    print("Advertising Identifier: \(adIdentifier)")
                case .denied:
                    // Kullanıcı izin vermedi.
                    print("App Tracking Transparency permission denied.")
                case .notDetermined:
                    // Kullanıcı henüz bir seçim yapmadı.
                    print("App Tracking Transparency permission not determined.")
                case .restricted:
                    // Kullanıcı cihazında izni kısıtlı.
                    print("App Tracking Transparency permission restricted.")
                @unknown default:
                    break
                }
            }
        } else {
            // iOS 14 öncesi sürümlerde kullanıcı iznini almak gerekmez, bu yüzden devam edebilirsiniz.
            let adIdentifier = ASIdentifierManager.shared().advertisingIdentifier
            print("Advertising Identifier: \(adIdentifier)")
        }
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

