//
//  LoyaltyStation.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 5/15/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import Foundation
import UIKit

/// Gamiphy SDK
public class LoyaltyStation {

    static var appId: String?
    static var user: User?
    static var agent: String?
    //TODO to handle to be more general
    static var environment: Environments = Environments.staging
    
    /// Notifications
    enum Notifications {
        static let didUpdateBotConfiguration    = NSNotification.Name.init("didUpdateBotConfiguration")
    }
    
    /// Bot view controller
    private static var webViewController: WebViewController?
    
    /// Delegate
    public static weak var delegate: LoyaltyStationDelegate?

    private static func getDomain(environment: Environments) -> String {
        switch environment {
        case Environments.dev:
            return "https://static-dev.gamiphy.co"
        case Environments.staging:
            return "https://static-staging.gamiphy.co"
        case Environments.prod:
            return "https://static.gamiphy.co"
        }
    }

    private static func getPath(agent: String?) -> String {
        switch agent {
        case "floward":
            return "/sdk/custom/floward/index.html"
        default:
            return "/sdk/android.html"
        }
    }

    public static func getUrl() -> String {
        return getDomain(environment: LoyaltyStation.environment) + getPath(agent: LoyaltyStation.agent)
    }

    /**
     Private initializer
     */
    private init() {
    }
    
    /**
     Initialize gamipy with the app id and secret key
     - Parameter appID: App Id.
     - Parameter options: Gamiphy bot options
     */
    public static func initialize(config: Config) {
        LoyaltyStation.appId = config.app
        LoyaltyStation.user = config.user
        LoyaltyStation.agent = config.agent

        webViewController = WebViewController()
    }
    
    /**
     Open bot on view controller
     - Parameter on: The view controller to show bot on.
     - Parameter language: The language to use for bot.
     */
    public static func open(on: UIViewController) {
        on.present(webViewController!, animated: true, completion: nil)
    }
    
    /**
     Close bot
     */
    public static func close() {
        webViewController?.dismiss(animated: true, completion: nil)
    }
    
    /**
        Login to the loyalty station
     */
    public static func login(user: User) {
        self.user = user;
        
        webViewController?.callLoginMethod(user: user)
    }
}

/// Gamiphy SDK Delegate
public protocol LoyaltyStationDelegate: NSObjectProtocol {
    /**
       The delegate will trigger when the loyalty station requires login / signup for the user.
        - Parameter isSignUp: go to sign screen if true else go to the login page
     */
    func onAuthTrigger(isSignUp: String)
}

public extension LoyaltyStationDelegate {
    /**
        The delegate will trigger when the loyalty station requires login / signup for the user.
         - Parameter isSignUp: go to sign screen if true else go to the login page
      */
    func onAuthTrigger(isSignUp: Bool) {}
}
