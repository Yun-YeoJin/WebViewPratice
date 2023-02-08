//
//  SearchTableViewCell.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/06.
//

import UIKit
import SnapKit

class SearchTableViewCell: BaseTableViewCell {
    
    let resultLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .boldSystemFont(ofSize: 17)
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }

    
    override func configureUI() {
        [resultLbl].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        resultLbl.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

    }
    
}
