//
//  SearchViewController.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/02.
//

import UIKit
import RxCocoa
import RxSwift

final class SearchViewController: BaseViewController {
    
    let mainView = SearchView()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        self.navigationItem.title = "WebView 사용하기"
    }
    
    func bind() {
    
        mainView.searchButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = WebViewController()
                vc.search = self?.mainView.searchTF.text!
                vc.url = "https://m.search.naver.com/search.naver?"
                self?.transition(vc, transitionStyle: .push)
            }).disposed(by: disposeBag)
    }
    
    
}
