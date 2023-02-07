//
//  SearchView.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/02.
//

import UIKit
import SnapKit
import Then

final class SearchView: BaseView {
    
    let searchTF = UITextField().then {
        $0.borderStyle = .bezel
        $0.placeholder = "검색을 해보세요!"
        $0.keyboardType = .webSearch
    }
    
    let searchButton = UIButton().then {
        $0.setTitle("검색", for: .normal)
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 8
    }
    
    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reusableIdentifier)
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGreen.cgColor
        $0.rowHeight = 60
        $0.separatorStyle = .singleLine
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureUI() {
        super.configureUI()
        
        [searchTF, searchButton, tableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        searchTF.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide).inset(44)
            make.height.equalTo(60)
        }
        
        searchButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(44)
            make.top.equalTo(searchTF.snp.bottom).offset(16)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(searchButton.snp.bottom).offset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
}
