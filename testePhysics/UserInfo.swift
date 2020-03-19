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
    
    var highScore: Int {
        didSet {
            UserDefaults.standard.set(self.highScore, forKey: "highScore")
        }
    } //TODO: userDefaults \ gamecenger
    var nodeArray: [SKNode] = []
    var numberOfPlays = 0
    var showedAd = false
    var showRewardedAd: Bool = false {
        didSet {
            UserDefaults.standard.set(self.showRewardedAd, forKey: "showRewardedAd")
        }
    }
    
    public static let shared = UserInfo()
    
    private init() {
        highScore = UserDefaults.standard.integer(forKey: "highScore")
        showRewardedAd = UserDefaults.standard.bool(forKey: "showRewardedAd")
    }
    
}
