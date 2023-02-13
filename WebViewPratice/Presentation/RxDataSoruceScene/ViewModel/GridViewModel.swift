//
//  GridViewModel.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/10.
//

import RxSwift

struct GridViewModel {
    
    let titles = BehaviorSubject<[String]>(value: [])
    
    init(titles: [String]) {
        self.titles.onNext(titles)
    }
    
}
