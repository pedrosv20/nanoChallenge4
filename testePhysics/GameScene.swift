//
//  GameScene.swift
//  testePhysics
//
//  Created by Pedro Vargas on 03/03/20.
//  Copyright © 2020 Pedro Vargas. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var node: SKSpriteNode!
    
    let builder = BlockBuilder()
    
    
    private let pieceArray = ["bar", "square", "teco", "tareco"]
    
    var textureCountArray = [1,2,3,4,5]
    
    var textureCount = 0
    
    let grid = 25
    
    override func didMove(to view: SKView) {
        
    }
    
    func createLine(x : CGFloat) -> SKShapeNode{
        let line = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLines(between: [CGPoint(x: x, y: 600), CGPoint(x: x, y: -600)])
        line.path = path
        line.strokeColor = .red
        line.zPosition = 2
    
        return line
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        /*
        //teco]
        let blockElement = pieceArray.randomElement()!
        let blockElementPosition = pieceArray.firstIndex(of: blockElement)!
        let texture = blockElement + "_" + (String((textureCount % 5) + 1))
        
        let block = builder.createBlock(texture: texture, path: BlockType.allCases[blockElementPosition])
        
        
        print(block.type)
        block.node.position = CGPoint(x: pos.x, y: 300 )
        block.node.anchorPoint = CGPoint(x: 0, y: 1)
//        block.node.texture = nil
        
        
        self.addChild(block.node)
        
        textureCount += 1
        
//        pieceArray.randomElement()! + "_" + (String((textureCount % 5) + 1))
//        textureCount += 1
//        let node = SKSpriteNode(texture: texture)
//        pieceNode.zPosition = 1
//
//
//
//        pieceNode.physicsBody = SKPhysicsBody(texture: pieceNode.texture!, size: pieceNode.size)
//
//        pieceNode.position = CGPoint(x: pos.x, y: 300 )
//        pieceNode.physicsBody?.affectedByGravity = true
//        pieceNode.physicsBody?.mass = 0.689066648483276
//        pieceNode.physicsBody?.linearDamping = 3
//
//        self.addChild(pieceNode)
//
        */
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        let newPosition = Double((Int(pos.x)%self.grid)*self.grid).rounded()
        print("actual position: \(pos.x)    :   position grid: \(newPosition)")
    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.right:
                    print("Swiped right")
                case UISwipeGestureRecognizer.Direction.down:
                    print("Swiped down")
                case UISwipeGestureRecognizer.Direction.left:
                    print("Swiped left")
                case UISwipeGestureRecognizer.Direction.up:
                    print("Swiped up")
                default:
                    break
                }
            }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
