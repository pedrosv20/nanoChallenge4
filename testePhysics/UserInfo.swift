//
//  File.swift
//  testePhysics
//
//  Created by Pedro Vargas on 13/03/20.
//  Copyright © 2020 Pedro Vargas. All rights reserved.
//

import Foundation
import SpriteKit

class UserInfo {
    
    var highScore = 0 //TODO: userDefaults \ gamecenger
    var nodeArray: [SKNode] = []
    var numberOfPlays = 0
    var showedAd = false
    var showRewardedAd = false
    
    public static let shared = UserInfo()
    
    private init() {}
}
