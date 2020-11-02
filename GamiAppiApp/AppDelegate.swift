import UIKit
import LoyaltyStation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LoyaltyStation
                .setApp(app: "5f71e34bdbaa0b0019df9c58")
            .setUser(user: User(id: "test-id", firstName: "Riyad", lastName: "Yahya", country: nil, referral: nil, hash: "237ccb1812cf2c893e341788921ec62515ca6d0507d7e4577055b25b794f831c"))
                .setAgent(agent: "floward")
                .setLanguage(language: "ar")
                .setSandbox(sandbox: true)
                .initialize()

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
