//
//  SafariViewModel.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/03.
//

import Foundation

import RxCocoa
import RxSwift

class SafariViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    var newsList: [NewsItems] = []
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let querySubject: PublishSubject<String>
        let sortSubject: PublishSubject<String>
        let startPageSubject: PublishSubject<Int>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        var newsData: PublishSubject<[NewsSectionModel]>
    }
    
    func transform(input: Input) -> Output {
        
        let newsData = PublishSubject<[NewsSectionModel]>()
        
        input.viewDidLoadEvent
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                newsData.onNext([])
                self?.newsList = []
            }.disposed(by: disposeBag)
        
        input.searchButtonTap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.newsList = []
                input.startPageSubject.onNext(0)
            }.disposed(by: disposeBag)
        
        Observable.combineLatest(input.querySubject, input.startPageSubject)
            .observe(on: SerialDispatchQueueScheduler(qos: .background))
            .flatMap { query, start -> Observable<[NewsItems]> in
                let observable = self.requestNewsAPI(query: query, display: 10, start: start + 1, sort: "sim")
                return observable
            }
            .subscribe { newsDetail in
                self.newsList.append(contentsOf: newsDetail)
                newsData.onNext([NewsSectionModel(items: self.newsList)])
            }.disposed(by: disposeBag)
        
        return Output(newsData: newsData)
    }
    
    func requestNewsAPI(query: String, display: Int, start: Int, sort: String) -> Observable<[NewsItems]> {
        
        return Observable<[NewsItems]>.create { observer in
            APIService.shared.requestNewsAPI(type: NaverNewsDTO.self, router: NaverNewsRouter.searchNaverNews(query: query, display: "\(display)", start: "\(start)", sort: sort)) { result in
                switch result {
                case .success(let success):
                    observer.onNext(success.items)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }.observe(on: SerialDispatchQueueScheduler(qos: .background))
    }
    
}
