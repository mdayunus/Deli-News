//
//  SelectedSourceFeed.swift
//  Deli News
//
//  Created by Mohammad Yunus on 09/05/19.
//  Copyright © 2019 taptap. All rights reserved.
//

import Foundation
// after getting error in some places because the var doesn't existed in json it is decided to make every var an optional

struct SelectedSourceFeed: Codable {
    var status: String?
    var totalResults: Int?
    var articles: [article]?
}
struct article: Codable {
    var source: Object?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}
struct Object: Codable {
    var id: String?
    var name: String?
}
