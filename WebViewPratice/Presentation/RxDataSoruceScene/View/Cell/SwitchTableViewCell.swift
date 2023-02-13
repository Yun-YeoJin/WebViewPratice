//
//  SwitchTableViewCell.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/10.
//

import UIKit
import RxSwift

class SwitchTableViewCell: BaseTableViewCell {
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "UISwitch가 있는 Cell"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mySwitch: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(mySwitch)
        
    }
    
    override func setConstraints() {
        titleLabel.centerXAnchor
            .constraint(equalTo: self.contentView.centerXAnchor)
            .isActive = true
        titleLabel.centerYAnchor
            .constraint(equalTo: self.contentView.centerYAnchor)
            .isActive = true
        
        mySwitch.rightAnchor
            .constraint(equalTo: self.contentView.rightAnchor, constant: -20)
            .isActive = true
        mySwitch.centerYAnchor
            .constraint(equalTo: self.contentView.centerYAnchor)
            .isActive = true
    }
    
    
  
}
