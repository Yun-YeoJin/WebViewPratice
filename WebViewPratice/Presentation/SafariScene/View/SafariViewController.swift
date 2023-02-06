//
//  SafariViewController.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/02.
//

import UIKit
import SafariServices
import JGProgressHUD
import RxCocoa
import RxSwift
import RxDataSources

final class SafariViewController: BaseViewController {
    
    let mainView = SafariView()
    let viewModel = SafariViewModel()
    private let hud = JGProgressHUD()
    var disposeBag = DisposeBag()
    
    var onData = PublishSubject<NewsItems>()
    
    private var page = 1
    
    override func loadView() {
        self.view = mainView
    }
    
    private var dataSources = RxCollectionViewSectionedReloadDataSource<NewsSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SafariCollectionViewCell", for: indexPath) as? SafariCollectionViewCell else { return UICollectionViewCell() }
        cell.onData.onNext(item)
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Safari"
        navigationItem.titleView = mainView.searchBar
        mainView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        mainView.collectionView.collectionViewLayout = collectionViewLayout()
        bindRX()
        
    }
    
    func bindRX() {
        
        let input = SafariViewModel.Input(viewDidLoadEvent: Observable.just(()), querySubject: PublishSubject<String>(), sortSubject: PublishSubject<String>(), startPageSubject: PublishSubject<Int>(), searchButtonTap: mainView.searchBar.rx.searchButtonClicked)
        
        let output = viewModel.transform(input: input)
        
        input.searchButtonTap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.hud.show(in: self!.mainView)
                input.querySubject.onNext(self?.mainView.searchBar.text ?? "")
                input.startPageSubject.onNext(self!.page)
                input.sortSubject.onNext("sim")
                self?.mainView.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                self?.hud.dismiss(animated: true)
                self?.mainView.searchBar.endEditing(true)
            }.disposed(by: disposeBag)
        
        output.newsData
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSources))
            .disposed(by: disposeBag)
            
        mainView.collectionView.rx
            .modelSelected(NewsItems.self)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { vc, data in
                let url = URL(string: data.link)
                let safari = SFSafariViewController(url: url!)
                safari.delegate = self
                safari.modalPresentationStyle = .automatic
                self.present(safari, animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        mainView.collectionView.rx
            .didScroll
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { vc, _ in
                if vc.mainView.collectionView.contentOffset.y == (self.mainView.collectionView.contentSize.height - self.mainView.collectionView.bounds.size.height) {
                    self.page += 1
                    input.startPageSubject.onNext(self.page)
                }
            }.disposed(by: disposeBag)
        
    }
    
}

extension SafariViewController: UICollectionViewDelegate, UIScrollViewDelegate, SFSafariViewControllerDelegate {
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let width = UIWindow().frame.size.width
        
        layout.itemSize = CGSize(width: width, height: width / 4 )
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 8 //위아래 아이템 간격
        layout.minimumInteritemSpacing = 8 //가로 아이템 간격
        
        return layout
    }
    
}
