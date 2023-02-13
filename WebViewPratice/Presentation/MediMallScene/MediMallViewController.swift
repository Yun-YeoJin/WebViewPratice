//
//  MediMallViewController.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/08.
//

import UIKit
import WebKit
import SnapKit
import JGProgressHUD
import SwiftUI

final class MediMallViewController: BaseViewController {
    
    private var webView: WKWebView = {
        let view = WKWebView()
        view.allowsBackForwardNavigationGestures = true
        view.scrollView.isScrollEnabled = true
        return view
    }()
    
    private var popUpView: WKWebView?
    
    private var hud = JGProgressHUD()
    
    var jsonString = String()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    deinit {
        print("deinit 되었습니다.")
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
        configureConsoleLog(webView: webView)
        
    }
    
    @objc func bindBtnTapped() {
        
        createJsonToPass(email: "duwls0349@gmail.com", name: "윤여진")
        
        webView.evaluateJavaScript("getName()") { (success, error) in
            
            print(success as Any)
            print(error?.localizedDescription as Any)
            
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
        contentController.add(LeakAvoider(delegate: self), name: "submitToiOS")
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = wkPreferences
        configuration.defaultWebpagePreferences = preferences
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        
    }
    
    private func requestMediUrl() {
        
        let userScript = WKUserScript(source: "getName()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(userScript)
        
        let mediComponents = URLComponents(string: "https://m-app.shop/")!
        let mediRequest = URLRequest(url: mediComponents.url!)
        webView.load(mediRequest)
        
    }
    
}

extension MediMallViewController: WKNavigationDelegate, WKUIDelegate {
    
    override func userContentController(
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
    
    //무조건 첫번째 실행
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(#function)
        print("navigationAction")
        
        hud.show(in: self.view, animated: true)
        
        if navigationAction.request.url?.absoluteString == "about:blank" {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.allow)
    }
    
    //3번째 실행
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(#function)
        print("navigationResponse")
        decisionHandler(.allow)
        print("탐색 요청에 대한 응답이 알려진 후 대리인에게 새 콘텐츠 탐색 권한을 요청")
        return
    }
    
    //2번째 실행
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
        print("주 프레임에서 탐색이 시작되었음을 대리자에게 알림")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
        print("웹 보기가 요청에 대한 서버 리디렉션을 수신했음을 대리자에게 알림")
    }
    
    func webView(_ webView: WKWebView, authenticationChallenge challenge: URLAuthenticationChallenge, shouldAllowDeprecatedTLS decisionHandler: @escaping (Bool) -> Void) {
        print(#function)
        print("사용되지 않는 버전의 TLS를 사용하는 연결을 계속할지 여부를 대리자에게 물음")
    }
    
    //4번째 실행
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        DispatchQueue.main.async {
            print(#function)
            print("웹 보기가 메인 프레임에 대한 콘텐츠를 수신하기 시작했음을 대리자에게 알림")
            
        }
    }
    
    //마지막 실행
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        print("탐색이 완료되었음을 대리자에게 알림")
        hud.dismiss(animated: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
        print("탐색 중 오류가 발생했음을 대리자에게 알림")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(#function)
        print("초기 탐색 프로세스 중에 오류가 발생했음을 대리자에게 알림")
    }
    
    //버튼 클릭 시 호출 후 runJavaScriptAlertPanelWithMessage로 이동
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print(#function)
        print("웹 보기의 콘텐츠 프로세스가 종료되었음을 대리자에게 알림")
    }
    
    //Alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print(#function)
        
        showAlert(title: "🌈세컨드닥터몰🌈", message: message, btnTitle: "확인", btnStyle: .default) { okAction in
            completionHandler()
        }   cancelBtnAction: { cancelAction in
            return
        }
        
    }
    
    //Confirm
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print(#function)
        
        showConfirm(title: "🌈세컨드닥터몰🌈", message: message, btnTitle: "확인", btnStyle: .default) { okAction in
            self.createJsonToPass(email: "duwls0349@gmail", name: "윤여진")
            completionHandler(true)
        } cancelBtnAction: { cancelAction in
            completionHandler(false)
        }
        
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
    
    func createJsonToPass(email: String, name : String) {
        
        let data = ["email": email, "name": name] as [String : Any]
        self.jsonString = createJsonForJavaScript(for: data)
        
    }
    
    func createJsonForJavaScript(for data: [String : Any]) -> String {
        var jsonString : String?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            
            jsonString = String(data: jsonData, encoding: .utf8)!
            jsonString = jsonString?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\\", with: "")
            
        } catch {
            print(error.localizedDescription)
        }
        print(jsonString!)
        return jsonString!
    }
    
}

