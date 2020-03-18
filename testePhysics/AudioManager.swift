//
//  AudioManager.swift
//  testePhysics
//
//  Created by José Guilherme Bestel on 17/03/20.
//  Copyright © 2020 Pedro Vargas. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class AudioManager {
    
    let lose :SKAction
    let blockOut :SKAction
    let blockTouch :SKAction
    let newRecord :SKAction
    let bg :SKAction
    
    init(){
        
        self.lose = SKAction.playSoundFileNamed("Lose.wav", waitForCompletion: true)
        self.blockOut = SKAction.playSoundFileNamed("Block Out.wav", waitForCompletion: true)
        self.blockTouch = SKAction.playSoundFileNamed("Block touch.wav", waitForCompletion: true)
        self.newRecord = SKAction.playSoundFileNamed("New Record with crowd.wav", waitForCompletion: true)
        self.bg = SKAction.repeatForever(SKAction.playSoundFileNamed("Towers Music.wav", waitForCompletion: true))
    }
}
