//
//  GamiphyUser.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 6/14/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import Foundation

/// Gamiphy User
public struct GamiphyUser : Decodable {
    
    /// Name
    public var name: String
    
    /// Email
    public var email: String
    
    /// Token
    public var token: String?
    
    /// Referral
    public var referral: GamiphyReferral?
    
    /// Coding keys
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case token
        case referral
    }
    
    /**
     Initializer
     */
    public init(name: String, email: String) {
        self.name = name
        self.email = email
        self.token = ""
    }
}
