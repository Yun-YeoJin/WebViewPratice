//
//  RxDataSource.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/10.
//

import RxDataSources
import UIKit

struct AdvancedDataSource {
    
    typealias DataSource = RxTableViewSectionedReloadDataSource
    
    static func dataSource() -> DataSource<AdvancedTableViewSection> {
        return .init(configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in
            
            switch dataSource[indexPath] {
            case let .TableViewInCollectionViewItem(titles):
                let cell = GridTableViewCell()
                cell.viewModel = GridViewModel(titles: titles)
                return cell
            case .IndicatorTableViewItem:
                let cell = IndicatorTableViewCell()
                cell.accessoryType = .disclosureIndicator
                return cell
            case let .SwitchTableViewItem(isOn):
                let cell = SwitchTableViewCell()
                cell.mySwitch.isOn = isOn
                return cell
            }
        }, titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        })
    }
    
}
