//
//  GamiphyWebViewController.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 5/15/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import UIKit
import WebKit

/// Gamiphy Web View Controller
class WebViewController: UIViewController, WKScriptMessageHandler {
    
    /// Loading View
    private(set) var loadingView:  UIView!

    /// Webview
    private var webView: WKWebView!
    
    /**
     Initilizer
     */
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = UIModalPresentationStyle.fullScreen
    }
    
    /**
     Initilizer
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.modalPresentationStyle = UIModalPresentationStyle.fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init webview
        self.initWebView()
        
        // Init loading view
        self.initLoadingView()

        // Set background color
        self.view.backgroundColor = UIColor.white;

        // Show loading view
        self.showHideLoadingView(true)
    }
    
    /**
     Init webview
     */
    private func initWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.minimumFontSize = 30

        let contentController = WKUserContentController()
        contentController.add(self, name: "onClose")
        contentController.add(self, name: "onAuthTrigger")

        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = preferences
        webConfiguration.processPool = WKProcessPool()
        webConfiguration.userContentController = contentController

        self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.webView.navigationDelegate = self
        self.webView.scrollView.bounces = false
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.webView)
        
        self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        if #available(iOS 11, *) {
            self.webView.topAnchor.constraint(equalToSystemSpacingBelow: self.view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0).isActive = true
        } else {
            self.webView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        }

        // Setup web view
        if let myURL = URL(string: LoyaltyStation.getUrl()) {
            let myRequest = URLRequest(url: myURL)
            self.webView.reload()
            self.webView.load(myRequest)
        }
    }

    /**
     Initialize Loading View
     */
    func initLoadingView() {
        
        // Init View
        self.loadingView = UIView(frame: CGRect.zero)
        self.loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.view.addSubview(self.loadingView)
        self.loadingView.isHidden = true
        
        // Init Activity Indicator
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityIndicator.tintColor = UIColor.blue
        activityIndicator.color = UIColor.blue

        activityIndicator.startAnimating()
        self.loadingView.addSubview(activityIndicator)
        
        // Add loading view constraints
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.loadingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        // Add Activity Indicator Constraints
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.loadingView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.loadingView.centerYAnchor).isActive = true
    }
    
    /**
     Show/Hide LoadingView
     - Parameter show : Bool value to show or hide loading view.
     */
    func showHideLoadingView(_ show : Bool) {
        self.view.bringSubviewToFront(self.loadingView)
        self.loadingView.isHidden = !show
    }

    func sendInitAction() {
        do {
            let config = """
                         app: '\(LoyaltyStation.appId!)',
                         onClose: function() {
                            webkit.messageHandlers.onClose.postMessage("close")
                         },
                         onAuthTrigger: function(isSignUp) {
                            webkit.messageHandlers.onAuthTrigger.postMessage(isSignUp)
                         }
                         """
            if(LoyaltyStation.user != nil) {
                let userData = try JSONEncoder().encode(LoyaltyStation.user);
                let userDataString = String(data: userData, encoding: .utf8);

                self.webView.evaluateJavaScript("""
                                                window.Gamiphy.init({
                                                \(config), 
                                                user: \(userDataString!)
                                                })
                                                """,
                        completionHandler: nil
                )
            } else {
                self.webView.evaluateJavaScript("""
                                                window.Gamiphy.init({
                                                \(config)
                                                })
                                                """,
                        completionHandler: nil
                )
            }
        } catch {print(error)}
    }

    func onClose() {
        LoyaltyStation.close()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "onClose":
            LoyaltyStation.close()
        case "onAuthTrigger":
            LoyaltyStation.delegate?.onAuthTrigger(isSignUp: message.body as! Bool)
        default:
            print("Not supported")
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let response = navigationResponse.response as? HTTPURLResponse,
            let url = navigationResponse.response.url else {
                decisionHandler(.cancel)
                return
        }
        
        if let headerFields = response.allHeaderFields as? [String: String] {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
            cookies.forEach { cookie in
                if #available(iOS 11.0, *) {
                    webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
                }
            }
        }
        
        decisionHandler(.allow)
    }
    
    /**
     Did fail to load
     */
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.showHideLoadingView(false)
        print(error)
    }
    
    /**
     Did fail to load
     */
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.showHideLoadingView(false)
        print(error)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showHideLoadingView(true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.showHideLoadingView(false);

        self.sendInitAction()
    }
}
