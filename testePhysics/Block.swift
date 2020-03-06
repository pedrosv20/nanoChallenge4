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
    let path: CGMutablePath
    let texture: SKTexture
    let type: BlockType
    
    init(path: CGMutablePath, texture: SKTexture, type: BlockType) {
        self.type = type
        self.path = path
        self.texture = texture
        self.node = SKSpriteNode(texture: texture)
        configNode()
    }
    
    func configNode() {
        self.node.zPosition = 1
        

     
        
//        self.node.physicsBody = SKPhysicsBody(polygonFrom: self.path)
        let physic =  SKPhysicsBody(polygonFrom: self.path)
        self.node.anchorPoint = CGPoint(x:0.5, y: 0.5)
        
        self.node.scale(to: CGSize(width: node.size.width * 1.1, height: node.size.height * 1.1))
        
        self.node.anchorPoint = CGPoint(x:0, y: 1)
        self.node.physicsBody = physic

        self.node.physicsBody = SKPhysicsBody(texture: self.texture, size: self.node.size)
//        self.node.physicsBody = SKPhysicsBody(polygonFrom: self.path)

        
//        self.node.physicsBody?.usesPreciseCollisionDetection = true
//        self.node.physicsBody?.affectedByGravity = true
//        self.node.physicsBody?.mass = 0.689066648483276
//        self.node.physicsBody?.friction = 1
//        self.node.physicsBody?.usesPreciseCollisionDetection = true
//        self.node.physicsBody?.linearDamping = 3

        
        
        
    }
}
