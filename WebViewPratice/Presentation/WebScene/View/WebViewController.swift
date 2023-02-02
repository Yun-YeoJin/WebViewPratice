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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWebView()
        self.navigationItem.title = search
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
    
    func setWebView() {
        
        let preferences = WKWebpagePreferences()
        /** javaScript 사용 설정 */
        preferences.allowsContentJavaScript = true
        /** 자동으로 javaScript를 통해 새 창 열기 설정 */
        let wkPreferences = WKPreferences()
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true
        
        let contentController = WKUserContentController()
        /** 사용할 메시지 등록 */
        contentController.add(self, name: "bridge")
        
        let configuration = WKWebViewConfiguration()
        /** preference, contentController 설정 */
        configuration.preferences = wkPreferences
        configuration.defaultWebpagePreferences = preferences
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        
        var components = URLComponents(string: url)!
        components.queryItems = [ URLQueryItem(name: "query", value: search) ]
        
        let request = URLRequest(url: components.url!)
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
        
        print("\(navigationAction.request.url?.absoluteString ?? "")" )
        
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
