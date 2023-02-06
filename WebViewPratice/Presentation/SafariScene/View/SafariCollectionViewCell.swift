//
//  SafariCollectionViewCell.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/03.
//

import UIKit
import SnapKit
import Then
import RxSwift

class SafariCollectionViewCell: BaseCollectionViewCell {
    
    var onData = PublishSubject<NewsItems>()
    
    var disposeBag = DisposeBag()
    
    let titleLbl = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    let pubDateLbl = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onData.observe(on: MainScheduler.instance)
            .subscribe { [weak self] in
                self?.titleLbl.text = String(htmlEncodedString: "\($0.element!.title)")
                self?.pubDateLbl.text = $0.element?.pubDate.toDate()?.toString()
            }.disposed(by: disposeBag)
    }
    
    override func configureUI() {
        [titleLbl, pubDateLbl].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        titleLbl.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        
        pubDateLbl.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(8)
            make.top.equalTo(titleLbl.snp.bottom).offset(12)
        }
    }
    
}
