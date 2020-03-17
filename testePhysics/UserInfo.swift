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
    
    public static let shared = UserInfo()
    
    private init() {}
}
