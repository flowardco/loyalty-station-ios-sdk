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
        options.hMacKey = "e71f524cee7995766626bd40350d883d14ded66dc095a3b89fb71b89faa751ce"
        options.clientID = "5dc9335e5d2ed200121fc720"
        options.language = "english"
        
        GamiphySDK.shared.initialize(botID: "5dc9335e5d2ed200121fc720", options: options)
        var user = GamiphyUser(name: "John Smith", email: "john@smith.com")
        user.referral = GamiphyReferral(code: "erwrw432")
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
    }
    
    func gamiphySDK(failedToAuthUser email: String) {
        print("dddd")
    }
    
    func gamiphySDKUserNotLoggedIn() {
        
    }
    
    func gamiphySDK(didTriggerRedeem packageID: String, pointsToRedeem: Int, value: Int) {
        GamiphySDK.shared.markRedeemDone(packageID: packageID, pointsToRedeem: pointsToRedeem)
    }

}

