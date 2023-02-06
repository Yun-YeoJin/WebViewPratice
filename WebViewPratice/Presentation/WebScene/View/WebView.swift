//
//  WebView.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/06.
//

import UIKit
import WebKit
import SnapKit
import Then

final class WebView: BaseView {
    
    var webView = WKWebView().then {
        $0.allowsBackForwardNavigationGestures = true
    }
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
        $0.sizeToFit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    override func configureUI() {
        super.configureUI()
        
        [webView, toolBar].forEach {
            self.addSubview($0)
        }

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let gobackButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(gobackButtonClicked))
        let goforwardButton = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(goforwardButtonClicked))
        let reloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(reloadButtonClicked))
        
        toolBar.tintColor = .systemGreen
        toolBar.items = [spacer, gobackButton, spacer, reloadButton, spacer, goforwardButton, spacer]
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        webView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(toolBar.snp.top)
        }
        toolBar.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    //MARK: objc func Methods
    @objc func gobackButtonClicked() {
        print(#function)
        webView.goBack()
    }
    
    @objc func goforwardButtonClicked() {
        print(#function)
        webView.goForward()
    }
    
    @objc func reloadButtonClicked() {
        print(#function)
        webView.reload()
    }
    
}
