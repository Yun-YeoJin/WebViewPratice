//
//  BaseViewController.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/02.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func setConstraints() { }
    
}
