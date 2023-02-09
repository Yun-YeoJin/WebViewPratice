//
//  LeakAvoider.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/09.
//

import UIKit
import WebKit

class LeakAvoider: NSObject, WKScriptMessageHandler {
    
    weak var delegate: WKScriptMessageHandler?
        init(delegate: WKScriptMessageHandler) {
            self.delegate = delegate
            super.init()
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            self.delegate?.userContentController(userContentController, didReceive: message)
        }
    
}
