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
    var minTick = 0
    let maxTick = 60
    
    private let pieceArray = ["bar", "square", "teco", "tareco"]
    
    var textureCountArray = [1,2,3,4,5]
    
    var textureCount = 0
    
    var isFalling = false
    
    var currentNode: SKNode?
    
    let grid = 25
    
    var guideRectangle: SKShapeNode?
    
    var background: SKNode?

    let swipeDown = UISwipeGestureRecognizer()
    let swipeLeft = UISwipeGestureRecognizer()
    let swipeRight = UISwipeGestureRecognizer()
    let tap = UITapGestureRecognizer()
    let pan = UIPanGestureRecognizer()
    
    var rotated = false
    
    
    override func didMove(to view: SKView) {
        
        background = childNode(withName: "background") as! SKSpriteNode
        
        background!.zPosition = 0
        createLinesGride()
        
        tap.addTarget(self, action:#selector(GameScene.tappedView(_:) ))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tap)
        
        swipeDown.addTarget(self, action: #selector(GameScene.swipedDown) )
        swipeDown.direction = .down
        self.view!.addGestureRecognizer(swipeDown)
        
        swipeRight.addTarget(self, action: #selector(GameScene.swipedRight) )
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)

        swipeLeft.addTarget(self, action: #selector(GameScene.swipedLeft) )
        swipeLeft.direction = .left
        self.view!.addGestureRecognizer(swipeLeft)
        
    }
    
    func createLinesGride(){
        let spaceLines = CGFloat(50/1)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        print("screenWidth: \(screenWidth)")
        let numberGrids = Int(screenWidth / spaceLines) - 2
        print("numberGrids: \(numberGrids)")
        
        //line center
        let centerLine = self.createLine(x: 0)
        centerLine.strokeColor = .blue
        //        addChild(centerLine)
        
        
        for i in 1...numberGrids{
            let x = CGFloat(i)*spaceLines
            addChild(self.createLine(x: x))
            addChild(self.createLine(x: -x))
            
        }
        
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
    
    
    func addBlockInScene() {
        self.isFalling = true
        let blockElement = pieceArray.randomElement()!
        let blockElementPosition = pieceArray.firstIndex(of: blockElement)!
        let texture = blockElement + "_" + (String((textureCount % 5) + 1))
        print("teste", texture)
        let block = builder.createBlock(texture: texture, path: BlockType.allCases[blockElementPosition])
        
        block.node.position = CGPoint(x: self.scene!.position.x, y: 400)
        
        self.currentNode = block.node
        
        guideRectangle = SKShapeNode(rect: CGRect(x: 0 - block.node.size.width / 2, y: -self.size.height/2, width: block.node.size.width, height: self.size.height))
        guideRectangle?.zPosition = 1
        guideRectangle!.fillColor = .blue
        guideRectangle!.alpha = 0.3
        
        
        self.addChild(self.currentNode!)
        self.addChild(guideRectangle!)
        
        
        textureCount += 1
        
    }
    
    @objc func swipedRight() {
        if currentNode != nil {
            let newPositionX = (round(Float(currentNode!.position.x + CGFloat(self.grid))/Float(self.grid)) * Float(self.grid))

        let newPositionY = Double(self.currentNode!.position.y)
        self.currentNode!.position = CGPoint(x: Double(newPositionX), y: newPositionY)
        self.guideRectangle!.position = CGPoint(x: Double(newPositionX), y: Double(self.guideRectangle!.position.y))
        }
    }
    
    @objc func swipedLeft() {
        if currentNode != nil {
            let newPositionX = (round(Float(currentNode!.position.x - CGFloat(self.grid))/Float(self.grid)) * Float(self.grid))

        let newPositionY = Double(self.currentNode!.position.y)
        self.currentNode!.position = CGPoint(x: Double(newPositionX), y: newPositionY)
        self.guideRectangle!.position = CGPoint(x: Double(newPositionX), y: Double(self.guideRectangle!.position.y))
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self))
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    func checkCollision() {
        
        // verifica se colidiu com outro bloco, cenario ou caiu pra fora
        print(currentNode)
        if self.currentNode != nil {
            
            if (self.currentNode!.physicsBody?.allContactedBodies().description.contains("Polygon"))! || (self.currentNode!.physicsBody?.allContactedBodies().description.contains("Rectangle"))! || (self.currentNode!.physicsBody?.allContactedBodies().description.contains("Compound"))!  {
                    
                    self.currentNode?.removeAllChildren()
                    self.currentNode = nil
                    self.isFalling = false
                    self.guideRectangle!.removeFromParent()
                }
                    
                    
            else if self.currentNode!.position.y <= CGFloat(-600) {
                    print("xobla")
                    self.currentNode?.removeAllChildren()
                    self.removeChildren(in: [self.currentNode!])
                    self.currentNode = nil
                    self.isFalling = false
                    self.guideRectangle!.removeFromParent()
                    
                }
            
        }
    }
    
    @objc func tappedView(_ sender:UITapGestureRecognizer) {
        
        
        if currentNode != nil {
            print("[tappedView] width before rotation \(self.currentNode!.frame.width)")
            self.currentNode!.zRotation -= .pi/2
            print("[tappedView] height before rotation \(self.currentNode!.frame.width)")
            if !rotated {
                if self.currentNode!.frame.width / self.currentNode!.frame.height > 1 {
                    self.guideRectangle?.xScale = 1 / (self.currentNode!.frame.width / self.currentNode!.frame.height)
                    print("[tappedView] Scaling by: \(1 / (self.currentNode!.frame.width / self.currentNode!.frame.height))")
                } else{
                    self.guideRectangle?.xScale = (self.currentNode!.frame.width / self.currentNode!.frame.height)
                    print("[tappedView] Scaling by: \(self.currentNode!.frame.width / self.currentNode!.frame.height))")
                }
                rotated = true
            } else {
                if self.currentNode!.frame.height / self.currentNode!.frame.width > 1 {
                    self.guideRectangle?.xScale = 1
                    print("[tappedView] Scaling by: \(self.currentNode!.frame.height / self.currentNode!.frame.width))")
                } else{
                    self.guideRectangle?.xScale = 1
                    print("[tappedView] Scaling by: \(1 / (self.currentNode!.frame.height / self.currentNode!.frame.width))")
                }
                rotated = false
            }
            
            
                
            
            
            
        }
    }

    
    
    @objc func swipedDown() {
    if currentNode != nil {
        currentNode?.physicsBody?.linearDamping = 0.1
    }
        print("Down")
    }
    
//    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
//
//        print(recognizer.translation(in: self.view))
//            print("tey", recognizer.translation(in: self.view))
//            if currentNode != nil {
//                let newPositionX = (round(Float(recognizer.translation(in: self.view).x)/Float(self.grid)) * Float(self.grid))
//
//                let newPositionY = Double(self.currentNode!.position.y)
//                self.currentNode!.position = CGPoint(x: Double(newPositionX), y: newPositionY)
//                self.guideRectangle!.position = CGPoint(x: Double(newPositionX), y: Double(self.guideRectangle!.position.y))
//            }
//
//    }
    
    override func update(_ currentTime: TimeInterval) {
        
        minTick += 1
        if minTick >= maxTick {
            if !isFalling {
                addBlockInScene()
            }
            minTick = 0
        }
        if currentNode?.physicsBody != nil {
            checkCollision()
        }
        
        
        
        
    }
}
