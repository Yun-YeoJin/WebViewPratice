//
//  APIService.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/03.
//

import Foundation
import Alamofire

class APIService: NaverNewsAPIProtocol {
    
    static let shared = APIService()
    
    private init() { }
    
    func requestNaverNewsAPI<T: Codable>(type: T.Type
                                     ,router: URLRequestConvertible
                                     ,completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(router).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
                dump(result)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
