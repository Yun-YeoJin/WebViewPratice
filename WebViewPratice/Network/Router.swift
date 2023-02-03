//
//  Router.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/03.
//

import Foundation
import Alamofire

enum NaverNewsRouter: URLRequestConvertible {
    
    case searchNaverNews(query: String, display: String, start: String, sort: String)
    
    var url: URL {
        switch self {
        case .searchNaverNews(query: let query, display: let display, start: let startpage, sort: let sort):
            return URL(string: EndPoint.baseURL)!
                .withQuery(param: ["query": query, "display": display, "start": startpage, "sort": sort])!
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .searchNaverNews(_, _, _, _):
            return [
                "X-Naver-Client-Id": APIKey.NAVER_ID,
                "X-Naver-Client-Secret": APIKey.NAVER_SECRET
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchNaverNews(_, _, _, _):
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = url
        var request = URLRequest(url: url)
        print(request)
        request.headers = header
        request.method = method
        switch self {
        case .searchNaverNews:
            return request
        }
    }
}
