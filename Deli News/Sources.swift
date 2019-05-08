//
//  Source.swift
//  Deli News
//
//  Created by Mohammad Yunus on 09/05/19.
//  Copyright © 2019 taptap. All rights reserved.
//

import Foundation
struct Sources: Codable {
    var status: String
    var sources: [Source]
}
struct Source: Codable {
    var id: String
    var name: String
    var description: String
    var url: String
    var category: String
    var language: String
    var country: String
}
