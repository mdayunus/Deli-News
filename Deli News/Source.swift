//
//  Source.swift
//  Deli News
//
//  Created by Mohammad Yunus on 09/05/19.
//  Copyright © 2019 taptap. All rights reserved.
//

import Foundation
struct Source: Codable {
    var id: String
    var name: String
    var description: String
    var url: URL?
    var category: String
    var language: String
    var country: String
}
