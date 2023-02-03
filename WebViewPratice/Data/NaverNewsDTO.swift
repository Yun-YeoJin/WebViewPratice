//
//  NaverNewsDTO.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/03.
//

import Foundation

// MARK: - NaverNewsDTO
struct NaverNewsDTO: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let originallink: String
    let link: String
    let description, pubDate: String
}
