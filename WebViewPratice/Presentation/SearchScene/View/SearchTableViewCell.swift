//
//  SearchTableViewCell.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/06.
//

import UIKit
import SnapKit

protocol ButtonTappedDelegate: AnyObject {
    func cellButtonTapped()
}

class SearchTableViewCell: BaseTableViewCell {
    
    let resultLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .boldSystemFont(ofSize: 17)
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    let deleteBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        view.tintColor = .white
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 8
        return view
    }()
    
    weak var delegate: ButtonTappedDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        deleteBtn.addTarget(self, action: #selector(deleteBtnClicked(_:)), for: .touchUpInside)
        
    }
    
    @objc func deleteBtnClicked(_ sender: UIButton) {
        delegate?.cellButtonTapped()
    }
    
    override func configureUI() {
        [resultLbl, deleteBtn].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        resultLbl.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(deleteBtn.snp.leading).offset(16)
        }
        deleteBtn.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(8)
            make.width.equalTo(40)
        }
    }
    
}
