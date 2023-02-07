//
//  TableViewSectionModel.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/07.
//

import Foundation
import RxDataSources

struct SearchResult { //MyModel
    var result: String
}

struct SearchResultSectionModel { //MySection
    var headerTitle: String
    var items: [Item]
}

extension SearchResultSectionModel: SectionModelType {
    
    typealias Item = SearchResult //MyModel
    
    init(original: SearchResultSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
    
}
