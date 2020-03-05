//
//  CGPathBlocks.swift
//  testePhysics
//
//  Created by Pedro Vargas on 05/03/20.
//  Copyright © 2020 Pedro Vargas. All rights reserved.
//

import Foundation
import SpriteKit
import CoreGraphics

class Block {
    let path: CGMutablePath!
    let texture: SKTexture
    
    init(path: CGMutablePath, texture: String) {
        self.path = path
        self.texture = SKTexture(imageNamed: texture)
    }
}
