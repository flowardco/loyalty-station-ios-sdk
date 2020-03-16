//
//  GamiphyReferral.swift
//  Gamibot
//
//  Created by Mohammad Nabulsi on 12/24/19.
//

import Foundation

/// Gamiphy Referral
public struct GamiphyReferral: Decodable {
    
    /// Code
    public var code: String

    /*
     Initilize
     */
    public init(code: String) {
        self.code = code
    }
}
