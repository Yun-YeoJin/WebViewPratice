//
//  IndicatorTableViewCell.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/10.
//

import UIKit
import RxSwift

class IndicatorTableViewCell: BaseTableViewCell {
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Indicator가 있는 Cell"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
    override func configureUI() {
        super.configureUI()
        
        self.contentView.addSubview(titleLabel)
        
        titleLabel.centerXAnchor
            .constraint(equalTo: self.contentView.centerXAnchor)
            .isActive = true
        titleLabel.centerYAnchor
            .constraint(equalTo: self.contentView.centerYAnchor)
            .isActive = true
    }
    
}
