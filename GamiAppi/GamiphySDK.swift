//
//  GamiphySDK.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 5/15/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import Foundation
import UIKit

/// Gamiphy SDK
public class GamiphySDK {
    
    /// Notifications
    enum Notifications {
        static let didUpdateBotConfiguration    = NSNotification.Name.init("didUpdateBotConfiguration")
    }
    
    /// Shared
    public static var shared = GamiphySDK()
    
    /// Bot view controller
    var botViewController: GamiphyWebViewController?
    
    /// Network Manager
    var networkManager: NetworkManager
    
    /// Configuration
    var configuration: BotConfiguration?
    
    /// Bot ID
    var botID: String
    
    /// Logged in user
    var user: GamiphyUser?
    
    /// Gamiphy bot options
    var options: GamiphyBotOptions
    
    /// Delegate
    public weak var delegate: GamiphySDKDelegate?
    
    /**
     Private initializer
     */
    private init() {
        self.networkManager = NetworkManager()
        self.botID = ""
        self.options = GamiphyBotOptions()
        
        // Initite webview
        self.botViewController = GamiphyWebViewController()
        self.botViewController?.delegate = self
    }
    
    /**
     Initialize gamipy with the app id and secret key
     - Parameter appID: App Id.
     - Parameter options: Gamiphy bot options
     */
    public func initialize(botID: String, options: GamiphyBotOptions) {
        self.botID = botID
        self.options = options
        
        // Load bot configuration
        self.loadBotConfiguration()
    }
    
    /**
     Refresh webview
     */
    public func refresh() {
        self.botViewController?.refresh()
    }

    /**
     Set debug value
     - Parameter debug: Debug enabled new value.
     */
    public func setDebug(_ debug: Bool) {
        self.options.debugEnabled = debug
    }
    
    /**
     Open bot on view controller
     - Parameter on: The view controller to show bot on.
     - Parameter language: The language to use for bot.
     */
    public func open(on: UIViewController, language: String? = "en") {
        self.options.language = language
        on.present(self.botViewController!, animated: true, completion: nil)
    }
    
    /**
     Close bot
     */
    public func close() {
        self.botViewController?.dismiss(animated: true, completion: nil)
    }
    
    /**
     Mark Redeem Done
     - Parameter packageID: The package id
     - Parameter pointsToRedeem: The points to redeem.
     */
    public func markRedeemDone(packageID: String, pointsToRedeem: Int) {
        self.networkManager.request(url: String(format: Apis.markRedeemDone.path, self.botID, packageID), method: "POST", keyPath: "",parameters: ["pointsToRedeem": pointsToRedeem], headers: ["Authorization": "JWT " + (self.user?.token ?? "")]) { (result: Result<[String: String?]?, Error>) in
            return
        }
    }
    
    /**
     Mark task Done
     - Parameter name: The task name.
     - Parameter arguments: Arguments to send with the task.
     */
    public func markTaskDone(name: String, arguments: [AnyHashable: String] = [:]) {
        let parameters: [String : Any] = ["eventName": name, "email": self.user?.email ?? "", "data": arguments]
        self.networkManager.request(url: String(format: Apis.trackTask.path, self.botID), method: "POST", keyPath: "", parameters: parameters) { (result: Result<[String: String], Error>) in
            return
        }
    }
    
    /**
     Auth user
     - Parameter user: User to authorize
     */
    public func authUser(user: GamiphyUser) {
        let hashValue = user.email + "|" + user.name
        let hash = hashValue.hmac(algorithm: CryptoAlgorithm.SHA256, key: GamiphySDK.shared.options.hMacKey)
        var parameters = ["name": user.name, "email": user.email, "hash": hash]
        if let referral = user.referral {
            parameters["referral"] = referral.code
        }
        self.networkManager.request(url: String(format: Apis.authApi.path, self.botID), method: "POST", keyPath: "", parameters: parameters) { (result: Result<AuthUserResponse, Error>) in
            switch result {
            case .success(let value):
                self.user = value.user
                self.user?.token = value.token
                self.delegate?.gamiphySDK(didAuthUser: user.name)
                break
            case .failure(let error):
                self.delegate?.gamiphySDK(failedToAuthUser: user.name, with: error)
                break
            }
        }
    }
    
    /**
     Load bot configuration
     */
    private func loadBotConfiguration() {
        self.networkManager.request(url: String(format: Apis.botConfiguration.path, self.botID), method: "GET", keyPath: "bot", parameters: [:]) { (result: Result<BotConfiguration, Error>) in
            switch result {
            case .success(let value):
                self.configuration = value
                NotificationCenter.default.post(name: Notifications.didUpdateBotConfiguration, object: nil)
                break
            case .failure(let error):
                print("failed to load bot configuration", error)
                break
            }
        }
    }
}

/// Gamiphy SDK Delegate
public protocol GamiphySDKDelegate: NSObjectProtocol {
    
    /**
     Did auth user
     - Parameter email: User email that has been authorized.
     */
    func gamiphySDK(didAuthUser email: String)
    
    /**
     Failed to auth user
     - Parameter email: User email that has not been authorized.
     - Parameter error: The error that caused the user not being authorized.
     */
    func gamiphySDK(failedToAuthUser email: String, with error: Error)
    
    /**
     Did trigger event with name
     - Parameter name: The event name that has been triggered.
     */
    func gamiphySDK(didTriggerEvent name: String)
    
    /**
     The delegate will trigger user not logged in when there is no logged in user for the bot and the user attept to trigger event.
     */
    func gamiphySDKUserNotLoggedIn()
    
    /**
     The delegate will trigger user not registered in when there is no logged in user for the bot and the user attept to trigger event.
     */
    func gamiphySDKUserNotRegistered()
    
    /**
     Did trigger Redeem
     - Parameter packageID: Package id
     - Parameter pointsToRedeem: The Points user going to redeem.
     - Parameter value: The amount value user going to redeem.
     */
    func gamiphySDK(didTriggerRedeem packageID: String, pointsToRedeem: Int, value: Int)
}

public extension GamiphySDKDelegate {
    
    /**
     Did auth user
     - Parameter email: User email that has been authorized.
     */
    func gamiphySDK(didAuthUser email: String) {}
    
    /**
     Failed to auth user
     - Parameter email: User email that has not been authorized.
     - Parameter error: The error that caused the user not being authorized.
     */
    func gamiphySDK(failedToAuthUser email: String, with error: Error) {}
    
    /**
     Did trigger event with name
     - Parameter name: The event name that has been triggered.
     */
    func gamiphySDK(didTriggerEvent name: String) {}
    
    /**
     The delegate will trigger user not logged in when there is no logged in user for the bot and the user attept to trigger event.
     */
    func gamiphySDKUserNotLoggedIn() {}
    
    /**
     The delegate will trigger user not registered in when there is no logged in user for the bot and the user attept to trigger event.
     */
    func gamiphySDKUserNotRegistered() {}
    
    /**
     Did trigger Redeem
     - Parameter packageID: Package id
     - Parameter pointsToRedeem: The Points user going to redeem.
     - Parameter value: The amount value user going to redeem.
     */
    func gamiphySDK(didTriggerRedeem packageID: String, pointsToRedeem: Int, value: Int) {}
}

// MARK: - GamiphyWebViewControllerDelegate
extension GamiphySDK: GamiphyWebViewControllerDelegate {
    
    /**
     The delegate will trigger user not logged in when there is no logged in user for the bot and the user attept to trigger event.
     */
    func webViewUserNotLoggedIn() {
        self.delegate?.gamiphySDKUserNotLoggedIn()
    }
    
    /**
     The delegate will trigger user not registered in when there is no logged in user for the bot and the user attept to trigger event.
     */
    func webViewUserNotRegistered() {
        self.delegate?.gamiphySDKUserNotRegistered()
    }
    
    /**
     Did trigger event
     - Parameter name: Event name
     */
    func webViewUser(didTriggerEvent name: String) {
        self.delegate?.gamiphySDK(didTriggerEvent: name)
    }
    
    /**
     Did trigger Redeem
     - Parameter packageID: Package id
     - Parameter pointsToRedeem: The Points user going to redeem.
     - Parameter value: The amount value user going to redeem.
     */
    func webViewUser(didTriggerRedeem packageID: String, pointsToRedeem: Int, value: Int) {
        self.delegate?.gamiphySDK(didTriggerRedeem: packageID, pointsToRedeem: pointsToRedeem, value: value)
    }
}
