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
    
    private let mainView = WebView()
    
    var search: String!
    var url: String!
    
    var popUpView: WKWebView?
    
    override func loadView() {
        self.view = mainView
    }
    
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
        
        configureNaviUI()
        self.mainView.webView.uiDelegate = self
        self.mainView.webView.navigationDelegate = self
        
        self.requestURL()
        //WebView configuration가 url요청 후 이루어져야 함.
        self.webViewConfig()
        configureConsoleLog(webView: mainView.webView)
                
    }
    
    deinit {
        print("deinit 되었습니다.")
    }
    
    private func configureNaviUI() {
        
        let popButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.2"), style: .done, target: self, action: #selector(popButtonClicked))
        navigationItem.leftBarButtonItems = [popButton]        
    }
    
    
    private func webViewConfig() {
        
        /** javaScript 사용 설정 */
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        /** 자동으로 javaScript를 통해 새 창 열기 설정 */
        let wkPreferences = WKPreferences()
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true
        
        /** preference, contentController 설정 */
        let contentController = WKUserContentController()
        contentController.add(LeakAvoider(delegate: self), name: "submitToiOS")
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = wkPreferences
        configuration.defaultWebpagePreferences = preferences
        configuration.userContentController = contentController
        
        mainView.webView = WKWebView(frame: self.view.bounds, configuration: configuration)
       
    }
    
    private func requestURL() {
        
        var components = URLComponents(string: self.url)!
        components.queryItems = [ URLQueryItem(name: "query", value: search) ]
        let request = URLRequest(url: components.url!)
        print(request)
        mainView.webView.load(request)
        
    }
    
}

//MARK: 이 메서드를 통해 Bridge가 들어오게 됨
extension WebViewController {
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print("Call 진입")
        print(message)
        
        if(message.name == "success") {
            print("success 호출 완료 \(message.body)")
        }
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
        
        showAlert(title: "test", message: message, btnTitle: "확인", btnStyle: .cancel) { okAction in
            completionHandler()
        }   cancelBtnAction: { cancelAction in
            return
        }

    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print(#function)
        
        showConfirm(title: "Test", message: message, btnTitle: "확인", btnStyle: .default) { okAction in
            completionHandler(true)
        } cancelBtnAction: { cancelAction in
            completionHandler(false)
        }

    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        popUpView = WKWebView(frame: self.view.bounds, configuration: configuration)
        popUpView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(popUpView!)
        popUpView?.uiDelegate = self
        
        return popUpView
        
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if webView == popUpView {
            popUpView?.removeFromSuperview()
            popUpView = nil
        }
    }

}

//MARK: Objc func Methods
extension WebViewController {
    
    @objc func popButtonClicked() {
        dismiss(animated: true)
    }
    
}


