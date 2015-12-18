//
//  AppDelegate.swift
//  illumi
//
//  Created by James Bampoe on 02/10/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        customiseAppearance()
        return true
    }

    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        ResourceManager.sharedInstance.didRegisterUserNotificationSettings(notificationSettings)
    }
    
    func customiseAppearance(){
        UITabBar.appearance().barTintColor = UIColor.lightGrayColor()
        UITabBar.appearance().tintColor = UIColor.blackColor()
    }
}

