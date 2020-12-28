import Foundation
import UIKit

/**
 * Gamiphy Loyalty Station sdk
 */
public class LoyaltyStation {
    /** Loyalty station app id **/
    internal var app: String? = nil

    /** Logged in user data **/
    internal var user: GLUser? = nil

    /** Gamiphy agent key **/
    internal var agent: String? = nil

    /** Preferable language **/
    internal var language: String? = nil

    /** Use sandbox **/
    internal var sandbox: Bool = false

    /** webview controller **/
    private var webViewController: WebViewController?

    /** Loyalty station delegate **/
    public static weak var delegate: LoyaltyStationDelegate?

    /** Loyalty station sdk instance **/
    public static var instance: LoyaltyStation = LoyaltyStation()

    /** Get loyalty station webview domain **/
    private func getDomain() -> String {
        if (self.sandbox) {
            return "https://static-staging.gamiphy.co"
        } else {
            return "https://static.gamiphy.co"
        }
    }

    /** Get loyalty station webview path **/
    private func getPath() -> String {
        switch self.agent {
        case "floward":
            return "/sdk/custom/floward/index.html"
        default:
            return "/sdk/android.html"
        }
    }

    /** Get loyalty station webview url **/
    public func getUrl() -> String {
        self.getDomain() + self.getPath()
    }

    /**
     Private initializer
     */
    private init() {
    }

    ///
    /// Set loyalty station app id
    /// - Parameter app: loyalty station app id
    /// - Returns: LoyaltyStation.Type
    public static func setApp(app: String) -> LoyaltyStation.Type {
        self.instance.app = app;

        return self
    }

    ///
    /// Set loyalty station user object
    /// - Parameter user: logged in user data
    /// - Returns: LoyaltyStation.Type
    public static func setUser(user: GLUser) -> LoyaltyStation.Type {
        self.instance.user = user;

        return self
    }

    ///
    /// Set custom agent
    /// - Parameter agent: custom ui key - provided by Gamiphy team
    /// - Returns: LoyaltyStation.Type
    public static func setAgent(agent: String) -> LoyaltyStation.Type {
        self.instance.agent = agent;

        return self
    }

    ///
    /// Set loyalty station language
    /// - Parameter language: preferred language to show
    /// - Returns: LoyaltyStation.Type
    public static func setLanguage(language: String) -> LoyaltyStation.Type {
        self.instance.language = language;

        return self
    }

    ///
    /// Enable sandbox
    /// - Parameter sandbox: indicates if sandbox enabled
    /// - Returns: LoyaltyStation.Type
    public static func setSandbox(sandbox: Bool) -> LoyaltyStation.Type {
        self.instance.sandbox = sandbox;

        return self
    }

    ///
    /// Initialize gamipy with the app id and secret key
    public static func initialize() {
        self.instance.webViewController = WebViewController();
    }

    ///
    /// Open loyalty station
    /// - Parameter on: The view controller to show loyalty station on.
    public static func open(on: UIViewController) {
        on.present(self.instance.webViewController!, animated: true, completion: nil)
    }

    ///
    /// Close loyalty station
    public static func close() {
        self.instance.webViewController?.dismiss(animated: true, completion: nil)
    }

    ///
    /// Login to the loyalty station
    /// - Parameter user: User data
    public static func login(user: GLUser) {
        self.instance.user = user;

        self.instance.webViewController?.callLoginMethod(user: user)
    }
}

///
/// Loyalty station delegate
public protocol LoyaltyStationDelegate: NSObjectProtocol {
    ///
    ///  The delegate will trigger when the loyalty station requires login / signup for the user.
    /// - Parameter isSignUp: go to sign screen if true else go to the login page
    func onAuthTrigger(isSignUp: String)
}

public extension LoyaltyStationDelegate {
    ///
    ///  The delegate will trigger when the loyalty station requires login / signup for the user.
    /// - Parameter isSignUp: go to sign screen if true else go to the login page
    func onAuthTrigger(isSignUp: Bool) {
    }
}
