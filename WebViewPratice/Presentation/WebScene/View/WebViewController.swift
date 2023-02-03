//
//  WebViewController.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/02.
//

import UIKit
import WebKit
import SnapKit
import Then

final class WebViewController: BaseViewController {
    
    private var webView = WKWebView()
    let webBackgroundView = UIView()
    
    var search: String!
    var url: String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "WebView"
        //SwipeBack Action 없애기
        //self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        
        requestURL()
        //WebView configuration가 url요청 후 이루어져야 함.
        webViewConfig()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
    }
    
    override func configureUI() {
        self.view.addSubview(webBackgroundView)
        webBackgroundView.addSubview(webView)
    }
    
    override func setConstraints() {
        webBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(additionalSafeAreaInsets)
        }
        webView.snp.makeConstraints { make in
            make.edges.equalTo(webBackgroundView.snp.edges)
        }
    }
    
    
    private func webViewConfig() {
        
        let preferences = WKWebpagePreferences()
        /** javaScript 사용 설정 */
        preferences.allowsContentJavaScript = true
        /** 자동으로 javaScript를 통해 새 창 열기 설정 */
        let wkPreferences = WKPreferences()
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true
        let contentController = WKUserContentController()
        contentController.add(self, name: "doneAction")
        let configuration = WKWebViewConfiguration()
        /** preference, contentController 설정 */
        configuration.preferences = wkPreferences
        configuration.defaultWebpagePreferences = preferences
        configuration.userContentController = contentController
      
        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
    }
    
    private func requestURL() {
        
        var components = URLComponents(string: url)!
        components.queryItems = [ URLQueryItem(name: "query", value: search) ]
        let request = URLRequest(url: components.url!)
        print(request)
        webView.load(request)
        
    }
    
}

extension WebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.request.url?.absoluteString == "about:blank" {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.allow)
    }
}

extension WebViewController: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
}
