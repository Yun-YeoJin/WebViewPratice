//
//  MediMallViewController.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/08.
//

import UIKit
import WebKit
import SnapKit

final class MediMallViewController: BaseViewController {
    
    private var webView = WKWebView()
    private var popUpView: WKWebView?
    
    var jsonString = String()
    
  
    
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
        
        navigationItem.title = "MediPlusSolutionMall"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeBtnTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "바인딩", style: .plain, target: self, action: #selector(bindBtnTapped))
        
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
   
        
        requestMediUrl()
        webViewConfig()
        configureConsoleLog()
        
        
    }
    
    @objc func bindBtnTapped() {
        
        createJsonToPass(email: "duwls0349@gmail.com", name: "윤여진")
        
        webView.evaluateJavaScript("getName()") { (success, error) in
            
            print(success)
            print(error?.localizedDescription)
            
        }
        
    }
    
    override func configureUI() {
        super.configureUI()
        
        [webView].forEach {
            view.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
    
    
    private func webViewConfig() {
        
        /* javaScript 사용 설정 */
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        /* 자동으로 javaScript를 통해 새 창 열기 설정 */
        let wkPreferences = WKPreferences()
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true
        
        /* contentController 설정 */
        let contentController = webView.configuration.userContentController
        contentController.add(self, name: "submitToiOS")
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = wkPreferences
        configuration.defaultWebpagePreferences = preferences
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        
    }
    
    private func configureConsoleLog() {
        
        // inject JS to capture console.log output and send to iOS
        let source = """
            function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); }
            window.console.log = captureLog;
        """
        let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        
        webView.configuration.userContentController.addUserScript(script)
        
        // register the bridge script that listens for the output
        webView.configuration.userContentController.add(self, name: "logHandler")
        
    }
    
    private func requestMediUrl() {
        
        let userScript = WKUserScript(source: "getName()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(userScript)
        
        let mediComponents = URLComponents(string: "https://m-app.shop/")!
        let mediRequest = URLRequest(url: mediComponents.url!)
        webView.load(mediRequest)
        

//        guard let path = Bundle.main.path(forResource: "index", ofType: "html") else { return }
//        let url = URL(fileURLWithPath: path)
//        let urlRequest = URLRequest(url: url)
//        webView.load(urlRequest)
        
    }
    
}

extension MediMallViewController: WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage) {
            
            switch message.name {
            case "submitToiOS":
                print("submitToiOS 호출 완료 \(message.body)")
            case "logHandler":
                print("console log: \(message.body)")
            default:
                print("error")
            }
            
        }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        //        if navigationAction.request.url?.absoluteString == "about:blank" {
        //            decisionHandler(.allow)
        //            return
        //        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
//        let alertController = UIAlertController(title: "어서오세요! 세컨드닥터몰입니다.", message: nil, preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "확인", style: .cancel)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    //Alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print(#function)
        let alertController = UIAlertController(title: "클릭되었습니다.", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) { _ in
            completionHandler()
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Confirm
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
    
    //Open Window
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
extension MediMallViewController {
    
    @objc func closeBtnTapped() {
        self.dismiss(animated: true)
    }
    
}

extension MediMallViewController {
    
    func createJsonToPass(email: String, name : String = "") {
        
        let data = ["email": email, "name": name] as [String : Any]
        self.jsonString = createJsonForJavaScript(for: data)
        
    }
    
    func createJsonForJavaScript(for data: [String : Any]) -> String {
        var jsonString : String?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            jsonString = String(data: jsonData, encoding: .utf8)!
            jsonString = jsonString?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\\", with: "")
            
        } catch {
            print(error.localizedDescription)
        }
        print(jsonString!)
        return jsonString!
    }
    
}
