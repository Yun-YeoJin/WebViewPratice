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
        self.navigationItem.title = "WebView"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(EditBtnTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Medi쇼핑몰", style: .plain, target: self, action: #selector(MediBtnTapped))
        mainView.searchTF.delegate = self
        mainView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    
    @objc func EditBtnTapped() {
        mainView.tableView.setEditing(true, animated: true)
        mainView.tableView.isEditing = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DoneBtnTapped))
    }
    
    @objc func DoneBtnTapped() {
        mainView.tableView.setEditing(false, animated: true)
        mainView.tableView.isEditing = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(EditBtnTapped))
    }
    
    @objc func MediBtnTapped() {
        transition(MediMallViewController(),transitionStyle: .presentFullNavigation)
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
                self?.tableViewRX(result: self?.mainView.searchTF.text ?? "검색어 없음")
            }).disposed(by: disposeBag)
        
    }
    
    private func tableViewRX(result: String) {
        
        dataSources = RxTableViewSectionedReloadDataSource(configureCell:  { dataSource, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reusableIdentifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
            cell.resultLbl.text = result
            return cell
        })
        
        sections.append(SearchResultSectionModel(
            headerTitle: "\(Date().toStringHistory()!) 에 검색됨.",
            items: [SearchResult(result: result)]
        ))
        
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
//            self.mainView.tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
//            self.mainView.tableView.deleteRows(at: [IndexPath(row: 0, section: indexPath.section)], with: .automatic)
            self.mainView.tableView.endUpdates()
            
            completion(true)
        }
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
}

