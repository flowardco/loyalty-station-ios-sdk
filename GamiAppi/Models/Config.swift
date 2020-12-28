//
//  Config.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 6/14/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import Foundation

public struct Config {
    public var app: String? = nil
    public var user: GLUser? = nil
    public var agent: String? = nil
    public var language: String? = nil
    
    public init(app: String) {
        self.app = app
    }
    
    public init(app: String, user: GLUser?) {
        self.app = app
        self.user = user
    }
    
    public init(app: String, agent: String?) {
        self.app = app
        self.agent = agent
    }
    
    public init(app: String, user: GLUser?, agent: String?) {
        self.app = app
        self.user = user
        self.agent = agent
    }
}
