//
//  NaverNewsAPIProtocol.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/13.
//

import Foundation
import Alamofire

protocol NaverNewsAPIProtocol {
    
    func requestNaverNewsAPI<T: Codable>(type: T.Type, router: URLRequestConvertible, completion: @escaping (Result<T, Error>) -> Void)
    
    
}

extension NaverNewsAPIProtocol {
    
    
    
}
