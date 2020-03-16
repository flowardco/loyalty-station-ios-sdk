//
//  BotLauncherStyle.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 5/18/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import Foundation

/// Bot Launcher Shape
enum BotLauncherShape: String, Decodable {
    case oval           = "Oval"
    case rectangle      = "Rectangle"
    case rhombus        = "Rhombus"
    case rounded        = "Rounded"
}

/// Bot Launcher Style
struct BotLauncherStyle: Decodable {
    
    /// Button
    var button: String?
    
    /// Shape
    var shape: BotLauncherShape?
    
    /// Icon
    var icon: String?
    
    /// Position
    var position: String?
}
