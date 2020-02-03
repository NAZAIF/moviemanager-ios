//
//  PostSession.swift
//  TheMovieManager
//
//  Created by Moideen Nazaif VM on 09/07/19.
//  Copyright © 2019 Moideen Nazaif VM. All rights reserved.
//

import Foundation

struct PostSession: Codable {
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
}

