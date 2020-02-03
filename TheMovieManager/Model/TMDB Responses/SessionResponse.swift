//
//  SessionResponse.swift
//  TheMovieManager
//
//  Created by Moideen Nazaif VM on 10/07/19.
//  Copyright © 2019 Moideen Nazaif VM. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    let success: Bool
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
    }
}
