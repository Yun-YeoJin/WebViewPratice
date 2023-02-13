//
//  RxDataSourceViewModel.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/10.
//

import RxSwift

struct RxDataSourceViewModel {

    let items = BehaviorSubject<[AdvancedTableViewSection]>(value: [
        .CollectionViewSection(items: [
            .TableViewInCollectionViewItem(titles: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"])
        ]),
        
        .CustomSection(items: [
            .IndicatorTableViewItem,
            .SwitchTableViewItem(isOn: true)
        ])
    ])
    
    let dataSource = AdvancedDataSource.dataSource()
}
