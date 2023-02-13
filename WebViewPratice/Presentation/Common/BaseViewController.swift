//
//  BaseViewController.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/02.
//

import UIKit
import WebKit

class BaseViewController: UIViewController, ConsoleLogProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureUI()
        setConstraints()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkMonitor.shared.startMonitoring()
    }
    
    func configureUI() { }
    
    func setConstraints() { }
    
    func configureConsoleLog(webView: WKWebView) {
        
        let source = """
            function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); }
            window.console.log = captureLog;
        """
        let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        
        webView.configuration.userContentController.addUserScript(script)
        webView.configuration.userContentController.add(LeakAvoider(delegate: self), name: "logHandler")
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
}

extension BaseViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}

//MARK: Objc func Methods
extension BaseViewController {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

