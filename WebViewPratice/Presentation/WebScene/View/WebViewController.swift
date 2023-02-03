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
    
    private var webView = WKWebView().then {
        $0.allowsBackForwardNavigationGestures = true
    }
    let toolBar = UIToolbar().then {
        $0.barStyle = .default
    }
    let webBackgroundView = UIView().then {
        $0.contentMode = .scaleAspectFit
    }
    
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
        
        navigationItem.title = "WebView"
        
        //SwipeBack Action 없애기
        //self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        
        requestURL()
        //WebView configuration가 url요청 후 이루어져야 함.
        webViewConfig()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
    }
    
    override func configureUI() {
        
        [webBackgroundView, toolBar].forEach {
            view.addSubview($0)
        }
        webBackgroundView.addSubview(webView)
        
        let popButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.2"), style: .done, target: self, action: #selector(popButtonClicked))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let gobackButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(gobackButtonClicked))
        let goforwardButton = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(goforwardButtonClicked))
        let refreshButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(refreshButtonClicked))
        toolBar.tintColor = .systemGreen
        toolBar.items = [spacer, gobackButton, spacer, refreshButton, spacer, goforwardButton, spacer]
        navigationItem.leftBarButtonItems = [popButton]
        
    }
    
    
    override func setConstraints() {
        webBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        webView.snp.makeConstraints { make in
            make.edges.equalTo(webBackgroundView.snp.edges)
        }
        toolBar.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            
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
        contentController.add(self, name: "naver")
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

//MARK: 이 메서드를 통해 Bridge가 들어오게 됨
extension WebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        print(message.body)
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.request.url?.absoluteString == "about:blank" {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}

extension WebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print(#function)
        let alertController = UIAlertController(title: "test", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) { _ in
            completionHandler()
        }
        alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print(#function)
        let alertController = UIAlertController(title: "test", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            completionHandler(false)
        }
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: objc func Methods
extension WebViewController {
    
    @objc func popButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func gobackButtonClicked() {
        print(#function)
        webView.goBack()
    }
    
    @objc func goforwardButtonClicked() {
        print(#function)
        webView.goForward()
    }
    
    @objc func refreshButtonClicked() {
        print(#function)
        webView.reload()
    }
}
