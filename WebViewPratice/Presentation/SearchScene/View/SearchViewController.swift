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
    
    private let mainView = SearchView()
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindRX()
        self.navigationItem.title = "WebView"
        mainView.searchTF.delegate = self
    }
    
    private func bindRX() {
        
        mainView.searchButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = WebViewController()
                vc.search = self?.mainView.searchTF.text!
                vc.url = "https://m.search.naver.com/search.naver?"
                self?.transition(vc, transitionStyle: .presentFullNavigation)
                self?.mainView.searchTF.endEditing(true)
            }).disposed(by: disposeBag)
    
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
