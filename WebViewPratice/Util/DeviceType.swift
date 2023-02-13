//
//  DeviceType.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/13.
//

import Foundation

enum DeviceType {
    case iPhoneSE2
    case iPhone8
    case iPhone13Pro
    case iPhone13ProMax

    func name() -> String {
        switch self {
        case .iPhoneSE2:
            return "iPhone SE"
        case .iPhone8:
            return "iPhone 8"
        case .iPhone13Pro:
            return "iPhone 13 Pro"
        case .iPhone13ProMax:
            return "iPhone 13 Pro Max"
        }
    }
}


