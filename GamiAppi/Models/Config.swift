//
//  Config.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 6/14/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import Foundation

public enum Environments : String, Decodable {
    case dev = "dev"
    case staging = "staging"
    case prod = "prod"
}

public struct Config {
    public var app: String
    public var user: User?
    public var agent: String?
    
    public init(app: String) {
        self.app = app
    }
    
    public init(app: String, user: User?) {
        self.app = app
        self.user = user
    }
    
    public init(app: String, agent: String?) {
        self.app = app
        self.agent = agent
    }
    
    public init(app: String, user: User?, agent: String?) {
        self.app = app
        self.user = user
        self.agent = agent
    }
}