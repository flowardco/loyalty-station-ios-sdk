//
//  BotConfiguration.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 5/18/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import Foundation

/// Bot Configuration
struct BotConfiguration: Decodable {
    
    /// ID
    var id: String
    
    /// Style
    var style: BotStyle
    
    /// Coding keys
    enum CodingKeys: String, CodingKey {
        case id                 = "_id"
        case style
    }
}
