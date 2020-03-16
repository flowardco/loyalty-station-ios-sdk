//
//  AuthUserResponse.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 5/15/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import Foundation

/// Auth User Response
struct AuthUserResponse: Decodable {
    
    /// User
    var user: GamiphyUser
    
    /// Token
    var token: String
}
