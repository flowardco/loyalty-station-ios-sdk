//
//  BotStyle.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 5/18/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import Foundation

/// Bot Style
struct BotStyle: Decodable {
    
    /// Brand color
    var brandColor: String?
    
    /// Background
    var background: String?
    
    /// Logo
    var logo: String?
    
    /// Welcome image
    var welcomeImage: String?
    
    /// Welcome Emoji
    var welcomeEmoji: String?
    
    /// Launcher
    var launcher: BotLauncherStyle
}
