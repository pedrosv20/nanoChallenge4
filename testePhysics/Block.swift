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
    let node: SKSpriteNode
    let texture: SKTexture
    
    let type: BlockType
    
    let tarecoPath = SKTexture(imageNamed: "tarecoPath")
    let tecoPath = SKTexture(imageNamed: "tecoPath")
    let barPath = SKTexture(imageNamed: "barPath")
    let squarePath = SKTexture(imageNamed: "squarePath")
    
    let tarecoSize = CGSize(width: 145.78, height: 95.83)
    let tecoSize = CGSize(width: 144.91, height: 95.95)
    let barSize = CGSize(width: 194.02, height: 45.08)
    let squareSize = CGSize(width: 96, height: 95.79)
    
    
    init(texture: SKTexture, type: BlockType) {
        self.type = type
        self.texture = texture
        self.node = SKSpriteNode(texture: texture)
        
        
        
        self.configNode(nodeTexture: texture)
        
    }
    
    func configNode(nodeTexture: SKTexture) {
        var physicsTexture: SKTexture? = nil
        var textureSize: CGSize? = nil
        switch type {
        case .Bar:
            physicsTexture = barPath
            textureSize = barSize
            break
        case .Square:
            physicsTexture = squarePath
            textureSize = squareSize
            break
        case .Tareco:
            physicsTexture = tarecoPath
            textureSize = tarecoSize
            break
        case .Teco:
            physicsTexture = tecoPath
            textureSize = tecoSize
            break
            
        }
        self.node.zPosition = 2
        
        self.node.physicsBody = SKPhysicsBody(texture: physicsTexture!, size: textureSize!)
 
        self.node.physicsBody?.usesPreciseCollisionDetection = true
        self.node.physicsBody?.affectedByGravity = true
        self.node.physicsBody?.mass = 1
        self.node.physicsBody?.friction = 1
        self.node.physicsBody?.linearDamping = 6
        self.node.physicsBody?.restitution = 0.001

        

        
        
        
    }
}
