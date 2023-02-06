//
//  ViewModelType.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/03.
//

import Foundation

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}
