//
//  AdvancedCollectionViewCell.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/10.
//

import UIKit

class GridCollectionViewCell: BaseCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }    
    
    lazy var roundedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func configureUI() {
        
        self.contentView.addSubview(roundedBackgroundView)
        roundedBackgroundView.addSubview(numberLabel)
            
    }
    
    override func setConstraints() {
        
        roundedBackgroundView.widthAnchor
            .constraint(equalTo: self.contentView.widthAnchor)
            .isActive = true
        roundedBackgroundView.heightAnchor
            .constraint(equalTo: self.contentView.heightAnchor)
            .isActive = true
        
        numberLabel.centerXAnchor
            .constraint(equalTo: roundedBackgroundView.centerXAnchor)
            .isActive = true
        
        numberLabel.centerYAnchor
            .constraint(equalTo: roundedBackgroundView.centerYAnchor)
            .isActive = true
        
    }
    
    
}





