//
//  AppDelegate.swift
//  LVS
//
//  Created by Jalal on 12/11/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        //UINavigationBar.appearance().setBackgroundImage(UIImage(named: "primary.png"), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        UINavigationBar.appearance().backgroundColor = Colors.getInstance().colorPrimary
        
        UINavigationBar.appearance().barTintColor = Colors.getInstance().colorPrimary
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue : UIColor.white])
        
        if #available(iOS 13.0, *) {
            let tag = 38482
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            if let statusBar = keyWindow?.viewWithTag(tag) {
                statusBar.backgroundColor = Colors.getInstance().colorPrimaryDark
            } else {
                if let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame {
                    let statusBarView = UIView(frame: statusBarFrame)
                    statusBarView.tag = tag
                    keyWindow?.addSubview(statusBarView)
                    statusBarView.backgroundColor = Colors.getInstance().colorPrimaryDark
                }
            }
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            
            statusBar?.backgroundColor = Colors.getInstance().colorPrimaryDark
        }
        
        // notificatins OneSigal code is :
        
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "e8158829-dc25-4f2a-bb4a-7b355338b571", handleNotificationReceived: { (notification) in
            //  print("Received Notification - \(notification?.payload.title)")
        }, handleNotificationAction: { (result) in
            // This block gets called when the user reacts to a notification received
        }, settings: [kOSSettingsKeyAutoPrompt : true, kOSSettingsKeyInAppAlerts : true])
        
      OneSignal.idsAvailable({ (userId, pushToken) in
    //OneSignal.getPermissionSubscriptionState()
            print("UserI iss :", userId!)
            
            UserDefaults.standard.set(userId, forKey: "deviceID")
            if UserDefaults.standard.value(forKey: "Token") != nil
            {
                let Token = UserDefaults.standard.value(forKey: "Token") as? String
                var lang : Int = 2
                if (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String == "ar"
                {
                    lang = 2
                }
                else
                {
                    lang = 1
                }
                
                Request.getInstance().requestService(object: self, model: "Membership", task: "RegisterDevice", getParameters: ["access_token": Token!, "device_token": userId!, "disable": "false", "lang": "\(lang)"], postParameters: [String: String]())
            }
            
        });
        
        
        
        
        // Override point for customization after application launch.
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
