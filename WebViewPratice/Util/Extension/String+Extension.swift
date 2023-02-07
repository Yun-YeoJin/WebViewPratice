//
//  String+Extension.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/06.
//

import Foundation

extension String {
    
    init?(htmlEncodedString: String) {
        
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString.string)
    }
    
    func replace( target: String,  withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func toDate() -> Date? { //"EEE, dd MMM yyyy HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
}

extension Date {
        
    func toString() -> String? {
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "yyyy년 MM월 dd일 - a hh:mm"
        return dateformatter.string(from: self)
    }
    
    func toStringHistory() -> String? {
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "yyyy/MM/dd - a hh:mm:ss"
        return dateformatter.string(from: self)
    }
    
}
