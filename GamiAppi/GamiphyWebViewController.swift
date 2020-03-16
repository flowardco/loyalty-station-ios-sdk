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
class GamiphyWebViewController: UIViewController, WKScriptMessageHandler {
    
    /// Loading View
    private(set) var loadingView:  UIView!
    
    /// Toolbar
    private(set) var toolbar: UIToolbar!
    
    /// Back bar button item
    private var backBarButtonItem: UIBarButtonItem!
    
    /// Webview
    private var webView: WKWebView!
    
    /// Delegate
    weak var delegate: GamiphyWebViewControllerDelegate?
    
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
        
        // Init toolbar
        self.initToolbar()
        
        // Set background color
        self.view.backgroundColor = UIColor.white
        if let brandColor = GamiphySDK.shared.configuration?.style.brandColor {
            self.view.backgroundColor = UIColor(hex: brandColor)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show loading view
        self.showHideLoadingView(true)
        
        // Setup web view
        if let myURL = URL(string: String(format: Apis.webView.path, GamiphySDK.shared.botID)) {
            let myRequest = URLRequest(url: myURL)
            self.webView.reload()
            self.webView.load(myRequest)
        }
    }
    
    /**
     Init webview
     */
    private func initWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.minimumFontSize = 30
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "goToPath")
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = contentController
        webConfiguration.preferences = preferences
        webConfiguration.processPool = WKProcessPool()
        
        var scriptSource = "window.postMessage({origin: 'Gamiphy', type: 'initialize'},'*')"
        
        if let user = GamiphySDK.shared.user {
            scriptSource = "window.postMessage({origin: 'Gamiphy', type: 'initialize', data: { user: '\(user.token ?? "")' \(GamiphySDK.shared.options.language == nil ? "" : ", language: '\(GamiphySDK.shared.options.language!)'")}},'*')"
        }
        
        let userScript = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(userScript)
        
        let source = "window.addEventListener('message', function(event){ console.log(JSON.stringify(event.data)); window.webkit.messageHandlers.goToPath.postMessage(JSON.stringify(event.data)); });"
        
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webConfiguration.userContentController.addUserScript(script)
        webConfiguration.userContentController.add(self, name: "iosListener")
        
        self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.scrollView.bounces = false
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.webView)
        
        self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            self.webView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0).isActive = true
        } else {
            self.webView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        }
    }
    
    /**
     Init Toolbar
     */
    private func initToolbar() {
        self.toolbar = UIToolbar()
        self.toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.toolbar.backgroundColor = UIColor.white
        self.view.addSubview(self.toolbar)
        
        self.toolbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.toolbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.toolbar.topAnchor.constraint(equalTo: self.webView.bottomAnchor).isActive = true
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            self.toolbar.bottomAnchor.constraint(equalToSystemSpacingBelow: guide.bottomAnchor, multiplier: 1.0).isActive = true
        } else {
            let standardSpacing: CGFloat = 0.0
            self.bottomLayoutGuide.topAnchor.constraint(equalTo: self.toolbar.bottomAnchor, constant: standardSpacing).isActive = true
        }
        
        self.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackImage"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.didClickBackButton))
        self.backBarButtonItem.isEnabled = self.webView.canGoBack
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.didClickCancelButton))
        self.toolbar.setItems([self.backBarButtonItem, UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), cancelButton], animated: false)
    }
    
    /**
     Did click cancel button
     */
    @objc private func didClickCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     Did click back button
     */
    @objc private func didClickBackButton() {
        if self.webView.canGoBack {
            self.webView.goBack()
        }
    }
    
    /**
     Refresh webview
     */
    func refresh() {
        self.webView.evaluateJavaScript("window.postMessage({origin: 'Gamiphy', type: 'reInitialize'},'*')", completionHandler: nil)
    }
    
    // MARK: - Loading view
    
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
        
        if let brandColor = GamiphySDK.shared.configuration?.style.brandColor {
            activityIndicator.tintColor = UIColor(hex: brandColor)
            activityIndicator.color = UIColor(hex: brandColor)
        }
        
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
    
    // MARK: - WKScriptMessageHandler
    
    /**
     Did receive message
     */
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        // Check if success
        if message.name == "goToPath", let body = message.body as? String {
            
            if let data = body.data(using: String.Encoding.utf8) {
                
                do {
                    if let dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        
                        // Check if origin in gamiphy
                        if let origin = dictonary["origin"] as? String, origin == "Gamiphy" {
                            
                            // Check if type in gotopath
                            if let type = dictonary["type"] as? String, type != "init", type != "initialize" {
                                
                                if type == "authTrigger" {
                                    if let data = dictonary["data"] as? NSDictionary, let isSignUp = data["isSignUp"] as? Bool {
                                        if isSignUp {
                                            self.delegate?.webViewUserNotRegistered()
                                        } else {
                                            self.delegate?.webViewUserNotLoggedIn()
                                        }
                                    }
                                } else if type == "actionTrigger" {
                                    if let data = dictonary["data"] as? NSDictionary, let actionName = data["actionName"] as? String {
                                        self.delegate?.webViewUser(didTriggerEvent: actionName)
                                    }
                                } else if type == "redeemTrigger" {
                                    if let data = dictonary["data"] as? NSDictionary, let packageID = data["packageId"] as? String, let pointsToRedeem = data["pointsToRedeem"] as? Int, let value = data["value"] as? Int {
                                        self.delegate?.webViewUser(didTriggerRedeem: packageID, pointsToRedeem: pointsToRedeem, value: value)
                                    }
                                }
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
}

// MARK: - WKNavigationDelegate
extension GamiphyWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        // Show loading view
        self.webView.load(navigationAction.request)
        return nil
    }
}

// MARK: - WKNavigationDelegate
extension GamiphyWebViewController: WKNavigationDelegate {
    
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
        self.backBarButtonItem.isEnabled = self.webView.canGoBack
        self.showHideLoadingView(false)
    }
}

/// Gamiphy Web View Controller Delegate
protocol GamiphyWebViewControllerDelegate: class {
    
    /**
     The delegate will trigger user not logged in when there is no logged in user for the bot and the user attept to trigger event.
     */
    func webViewUserNotLoggedIn()
    
    /**
     The delegate will trigger user not registered in when there is no logged in user for the bot and the user attept to trigger event.
     */
    func webViewUserNotRegistered()
    
    /**
     Did trigger event
     - Parameter name: Event name
     */
    func webViewUser(didTriggerEvent name: String)
    
    /**
     Did trigger Redeem
     - Parameter packageID: Package id
     - Parameter pointsToRedeem: The Points user going to redeem.
     - Parameter value: The amount value user going to redeem.
     */
    func webViewUser(didTriggerRedeem packageID: String, pointsToRedeem: Int, value: Int)
}
