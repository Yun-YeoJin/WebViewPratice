//
//  SearchViewController.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/02.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

final class SearchViewController: BaseViewController {
    
    private let mainView = SearchView()
    private var disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()
    
    private var dataSources: RxTableViewSectionedReloadDataSource<SearchResultSectionModel>?
    
    var sections: [SearchResultSectionModel] = []
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindRX()
        self.navigationItem.title = "WebView"
        mainView.searchTF.delegate = self
        mainView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        dataSources?.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        
    }
    
    private func bindRX() {
        
        mainView.searchButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let vc = WebViewController()
                vc.search = self?.mainView.searchTF.text!
                vc.url = "https://m.search.naver.com/search.naver?"
                self?.transition(vc, transitionStyle: .presentFullNavigation)
                self?.mainView.searchTF.endEditing(true)
                self?.mainView.tableView.dataSource = nil
                self?.tableViewRX(result: self?.mainView.searchTF.text ?? "")
            }).disposed(by: disposeBag)
        
    }
    
    private func tableViewRX(result: String) {
        
        dataSources = RxTableViewSectionedReloadDataSource(configureCell:  { dataSource, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reusableIdentifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
            cell.resultLbl.text = result
            cell.delegate = self
            return cell
        })
        
        sections.append(SearchResultSectionModel(
            headerTitle: "\(Date().toStringHistory()!) 에 검색됨.",
            items: [SearchResult(result: result)]
        ))
        
        dataSources?.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].headerTitle
        }
        
        let data = Observable<[SearchResultSectionModel]>.just(sections)
        
        data
            .bind(to: mainView.tableView.rx.items(dataSource: dataSources!))
            .disposed(by: disposeBag)
        
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

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SearchViewController: ButtonTappedDelegate {
    
    func cellButtonTapped() {
        print("버튼이 클릭 되었습니다.")
    }
    
}
