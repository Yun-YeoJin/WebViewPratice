//
//  RxDataSourceSectionModel.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/10.
//

import Foundation
import RxDataSources

enum AdvancedTableViewItem {
    
    case TableViewInCollectionViewItem(titles: [String])
    case SwitchTableViewItem(isOn: Bool)
    case IndicatorTableViewItem
    
}

enum AdvancedTableViewSection {
    case CollectionViewSection(items: [AdvancedTableViewItem])
    case CustomSection(items: [AdvancedTableViewItem])
}

extension AdvancedTableViewSection: SectionModelType {
    typealias Item = AdvancedTableViewItem

    var header: String {
        switch self {
        case .CollectionViewSection:
            return "CollectionView Section"
        case .CustomSection:
            return "Custom Section"
        }
    }
    
    var items: [AdvancedTableViewItem] {
        switch self {
        case .CollectionViewSection(items: let items):
            return items
        case .CustomSection(items: let items):
            return items
        }
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
