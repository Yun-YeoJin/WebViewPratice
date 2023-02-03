//
//  SafariView.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/02.
//

import UIKit
import SnapKit

final class SafariView: BaseView {
    
    var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.register(SafariCollectionViewCell.self, forCellWithReuseIdentifier: "SafariCollectionViewCell")
        return view
    }()
    
    let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "뉴스 키워드를 검색해보세요."
        view.searchBarStyle = .default
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureUI() {
        
        [collectionView].forEach {
            self.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    
}
