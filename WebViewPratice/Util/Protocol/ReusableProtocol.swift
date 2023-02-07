//
//  ReusableProtocol.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/06.
//


import UIKit

protocol ReusableProtocol {
    static var reusableIdentifier: String { get }
}

extension UICollectionViewCell: ReusableProtocol {
    
    static var reusableIdentifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: ReusableProtocol {
    
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
