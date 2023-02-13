//
//  GridTableViewCell.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/10.
//

import UIKit
import RxSwift

class GridTableViewCell: BaseTableViewCell {
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var viewModel: GridViewModel! {
        didSet {
            self.configure()
        }
    }
    
    let cellWidthHeightConstant: CGFloat = 100
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView
            .translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView
            .register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.reusableIdentifier)
        return collectionView
    }()
}

// MARK: - Binding
extension GridTableViewCell {
    private func bindCollectionView() {
        viewModel.titles
            .bind(to:
                    collectionView.rx.items(cellIdentifier: GridCollectionViewCell.reusableIdentifier, cellType: GridCollectionViewCell.self)) { indexPath, title, cell in
                
                cell.numberLabel.text = title
                
            }
                                            .disposed(by: disposeBag)
        
    }
}

// MARK: - Configuration
extension GridTableViewCell {
    private func configure() {
        self.bindCollectionView()
    }
}

// MARK: - UI Setup
extension GridTableViewCell {
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.contentView.addSubview(collectionView)
        
        collectionView.widthAnchor
            .constraint(equalTo: self.contentView.widthAnchor)
            .isActive = true
        collectionView.heightAnchor
            .constraint(equalTo: self.contentView.heightAnchor)
            .isActive = true
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let numberOfCells = floor(self.contentView.frame.size.width / cellWidthHeightConstant)
        let edgeInsets = (self.contentView.frame.size.width - (numberOfCells * cellWidthHeightConstant)) / (numberOfCells + 1)
        
        print(edgeInsets)
        
        layout.itemSize = CGSize(
            width: cellWidthHeightConstant,
            height: cellWidthHeightConstant)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: edgeInsets,
            bottom: 0,
            right: edgeInsets)
        
        return layout
    }
}
