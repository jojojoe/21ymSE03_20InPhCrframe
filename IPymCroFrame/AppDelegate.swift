//
//  AppDelegate.swift
//  IPymCroFrame
//
//  Created by mac on 2021/10/22.
//

import UIKit
import AppTrackingTransparency


//com.cropic.frameking

let AppName: String = "Effect Booster"
let purchaseUrl = ""
let TermsofuseURLStr = "https://www.app-privacy-policy.com/live.php?token=wsiJtnuMyskiojqmuSrQnY2K7js9gWrk"
let PrivacyPolicyURLStr = "http://thirsty-structure.surge.sh/Facial_Privacy_Policy.html"

let feedbackEmail: String = "mohs.cosj@yandex.com"
let AppAppStoreID: String = ""


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        NotificationCenter.default.addObserver(self, selector: #selector(applicDidBecomeActiveNotifi(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        registerNotifications(application)
        
        HightLigtingHelper.default.initSwiftStoryKit()
        NotificationCenter.default.post(name: .didFinishLaunching, object: nil)
        
        
        return true
    }

//    @objc func applicDidBecomeActiveNotifi(_ notifi: Notification) {
//        // Start the SDK (start the IDFA timeout set above, for iOS 14 or later)
//        trackeringAuthor()
//    }
    func trackeringAuthor() {
       
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: {[weak self] status in
                guard let `self` = self else {return}
                
            })
        }
    }
    
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         
    }


}


extension AppDelegate {
    // ????????????????????????
    func registerNotifications(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.getNotificationSettings { (setting) in
            if setting.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.badge,.sound,.alert]) { (result, error) in
                    if (result) {
                        if !(error != nil) {
                            // ????????????
                            DispatchQueue.main.async {
                                application.registerForRemoteNotifications()
                            }
                        }
                    } else {
                        //?????????????????????
                    }
                }
            } else if (setting.authorizationStatus == .denied){
                // ????????????????????????
            } else if (setting.authorizationStatus == .authorized){
                // ??????????????????????????????dt???
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                // ????????????
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let body = notification.request.content.body
        notification.request.content.userInfo
        print(body)
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("")
        let categoryIdentifier = response.notification.request.content.categoryIdentifier
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
}
