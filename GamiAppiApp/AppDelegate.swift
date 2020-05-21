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
        // Override point for customization after application launch.'
        GamiphySDK.shared.delegate = self
        
        var options = GamiphyBotOptions()
        GamiphySDK.shared.setDebug(true) // choose false for producation env
        options.hMacKey = "94c711455c8fabb3c3ffacace7711eda10be9d1147afa140872af60b026ebfca"
        GamiphySDK.shared.initialize(botID: "5e550cb17686f0001299e853", options: options)
        let user = GamiphyUser(name: "Abdallah AbuSalah", email: "abdallah@gamiphy.co")
        GamiphySDK.shared.authUser(user: user)
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

extension AppDelegate: GamiphySDKDelegate {
    
    func gamiphySDK(didAuthUser email: String) {
        print(email)
    }
    
    func gamiphySDK(failedToAuthUser email: String) {
    }
    
    func gamiphySDKUserNotLoggedIn() {
        var user = GamiphyUser(name: "Abdallah AbuSalah", email: "abdallah@gamiphy.co")
        GamiphySDK.shared.authUser(user: user)
    }
    func gamiphySDK(didTriggerEvent name: String){
        GamiphySDK.shared.markTaskDone(name: "openBugEvent")
    }
    
    func gamiphySDK(didTriggerRedeem packageID: String, pointsToRedeem: Int, value: Double) {
        print(GamiphySDK.shared.markRedeemDone(packageID: packageID, pointsToRedeem: pointsToRedeem))
    }

}

