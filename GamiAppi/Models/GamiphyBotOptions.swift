//
//  GamiphyBotOptions.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 6/14/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import Foundation

/// Gamiphy Bot Options
public struct GamiphyBotOptions {
    
    /// Hmac key
    public var hMacKey: String
    
    /// Cleant id
    public var clientID: String
    
    /// language
    public var language: String?
    
    /// Debug enabled
    var debugEnabled: Bool = true
    
    /**
     Initialize
     */
    public init () {
        self.hMacKey = ""
        self.clientID = ""
        self.language = nil
        self.debugEnabled = true
    }
}
