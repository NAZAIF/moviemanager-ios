//
//  MovieResults.swift
//  TheMovieManager
//
//  Created by Moideen Nazaif VM on 09/07/19.
//  Copyright © 2019 Moideen Nazaif VM. All rights reserved.
//

import Foundation

struct MovieResults: Codable {
    
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
}
