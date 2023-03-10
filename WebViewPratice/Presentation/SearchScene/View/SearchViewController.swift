//
//  SearchViewController.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/02.
//

import UIKit
import SnapKit
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
        configureNaviUI()
        mainView.searchTF.delegate = self
        mainView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    
    private func configureNaviUI() {
        self.navigationItem.title = "WebView"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Medi쇼핑몰", style: .plain, target: self, action: #selector(MediBtnTapped))
    }
    
    @objc func MediBtnTapped() {
        transition(MediMallViewController(),transitionStyle: .presentFullNavigation)
    }
    
    private func bindRX() {
        
        mainView.searchButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.goToWebVC()
                self?.mainView.searchTF.endEditing(true)
                self?.mainView.tableView.dataSource = nil
                self?.tableViewRX(result: self?.mainView.searchTF.text ?? "검색어 없음")
            }).disposed(by: disposeBag)
        
    }
    
    private func goToWebVC() {
        let vc = WebViewController()
        vc.search = mainView.searchTF.text!
        vc.url = "https://m.search.naver.com/search.naver?"
        transition(vc, transitionStyle: .presentFullNavigation)
    }
    
    
    private func tableViewRX(result: String) {
        
        sections.append(SearchResultSectionModel(
            headerTitle: "\(Date().toStringHistory()!) 에 검색됨.",
            items: [SearchResult(result: result)]
        ))
        
        dataSources = RxTableViewSectionedReloadDataSource(configureCell:  { dataSource, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reusableIdentifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
            cell.resultLbl.text = item.result
        
            return cell
        })
        
        dataSources?.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].headerTitle
        }
        
        dataSources?.canEditRowAtIndexPath = { dataSource, index in
            return true
        }
        
        dataSources?.canMoveRowAtIndexPath = { dataSource, index in
            return false
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { action, view, completion in
            print("Section: \(indexPath.section.description)")
            print("Rows : \(indexPath.row.description)")
            self.mainView.tableView.beginUpdates()
            self.mainView.tableView.deleteSections([indexPath.section], animationStyle: .automatic)
//            self.mainView.tableView.deleteRows(at: [IndexPath(row: 0, section: indexPath.section)], with: .automatic)
            self.mainView.tableView.endUpdates()
            
            completion(true)
        }
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
}

