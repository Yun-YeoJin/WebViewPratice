//
//  NewsSectionModel.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/03.
//

import Foundation

import RxDataSources

struct NewsSectionModel: SectionModelType {
    
    var items: [Item]
    
    init(items: [NewsItems]) {
        self.items = items
    }
    
    typealias Item = NewsItems
    
    init(original: NewsSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
    
}
