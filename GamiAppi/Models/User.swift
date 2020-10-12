//
//  User.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 6/14/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import Foundation

public struct User: Encodable, Decodable {
    public var id: String?
    public var firstName: String
    public var lastName: String
    public var email: String?
    public var hash: String?

    public init(id: String, firstName: String, lastName: String, hash: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.hash = hash
    }

    public init(email: String, firstName: String, lastName: String, hash: String?) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.hash = hash
    }
}