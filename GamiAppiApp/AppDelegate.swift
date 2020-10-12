//
//  AppDelegate.swift
//  GamiAppiApp
//
//  Created by Abdallah on 3/16/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit
import Gamibot

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LoyaltyStation.initialize(config: Config(app: "5f71e34bdbaa0b0019df9c58", user: User(id: "test-id", firstName: "Riyad", lastName: "Yahya", hash: "237ccb1812cf2c893e341788921ec62515ca6d0507d7e4577055b25b794f831c"), agent: "floward"))

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

extension AppDelegate: LoyaltyStationDelegate {
    public func onAuthTrigger(isSignUp: String) {
        //Make your action here, you may start login activity
        print("onAuthTrigger")
    }
}
