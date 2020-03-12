//
//  GameScene.swift
//  testePhysics
//
//  Created by Pedro Vargas on 03/03/20.
//  Copyright © 2020 Pedro Vargas. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, UIGestureRecognizerDelegate {
    
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
    var rotated = false
    var touchStart: DispatchTime!
    var touchEnd: DispatchTime!
    var startPos: CGFloat!
    var panGesture: UIPanGestureRecognizer!
    var didSwipe = false
    var playEnable = false
    var labelPlay: SKLabelNode?
    var baseNode: SKNode?
    
    var minTickIntro = 0
    var maxTickIntro = 20
    
    var introArray: [SKNode] = []
    
    override func didMove(to view: SKView) {
        
        background = childNode(withName: "background") as! SKSpriteNode
        background!.zPosition = 0
       
        baseNode = childNode(withName: "baseNode") as! SKSpriteNode
        
        baseNode!.zPosition = 1
        baseNode?.physicsBody?.isDynamic = false
        
        labelPlay = (childNode(withName: "playLabel") as! SKLabelNode)
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let sequence  = SKAction.sequence([fadeIn,fadeOut])
        labelPlay?.run(SKAction.repeatForever(sequence))
        labelPlay?.zPosition = 4
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestured))
        panGesture.delegate = self
        self.view?.addGestureRecognizer(panGesture)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipe.delegate = self
        swipe.direction = .down
        self.view?.addGestureRecognizer(swipe)
    }
    
    @objc func handleSwipeDown() {
        dropBlock()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }

    func createLinesGride(){
        let spaceLines = CGFloat(50/1)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
//        print("screenWidth: \(screenWidth)")
        let numberGrids = Int(screenWidth / spaceLines) - 2
//        print("numberGrids: \(numberGrids)")
        
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
//        print("teste", texture)
        let block = builder.createBlock(texture: texture, path: BlockType.allCases[blockElementPosition])
        let xPos = CGFloat.random(in: (self.scene!.position.x - 200) ..< (self.scene!.position.x + 200))
        
        let maxX = self.view!.bounds.width/2 + block.node.size.width/2
        let minX = -1 * maxX
        
        block.node.position = CGPoint(x: round(min(max(minX, xPos), maxX)), y: 400)
        
        self.currentNode = block.node
        
        guideRectangle = SKShapeNode(rect: CGRect(x: 0 - block.node.size.width / 2, y: -self.size.height/2, width: block.node.size.width, height: self.size.height))
        guideRectangle?.zPosition = 1
        guideRectangle!.fillColor = .blue
        guideRectangle!.alpha = 0.3
        guideRectangle?.position.x = self.currentNode!.position.x
        
        
        self.addChild(self.currentNode!)
        self.addChild(guideRectangle!)
        
        
        textureCount += 1
        
    }
    
    func addBlockInSceneIntro() {
        self.isFalling = true
        let blockElement = pieceArray.randomElement()!
        let blockElementPosition = pieceArray.firstIndex(of: blockElement)!
        let texture = blockElement + "_" + (String((textureCount % 5) + 1))
        //        print("teste", texture)
        let block = builder.createBlock(texture: texture, path: BlockType.allCases[blockElementPosition])
        let xPos = CGFloat.random(in: (self.scene!.position.x - 200) ..< (self.scene!.position.x + 200))
        
        let maxX = self.view!.bounds.width/2 + block.node.size.width/2
        let minX = -1 * maxX
        
        block.node.position = CGPoint(x: round(min(max(minX, xPos), maxX)), y: 400)
        block.node.physicsBody = nil
        block.node.run(SKAction.moveTo(y: (self.camera?.position.y)! - 100, duration: 0.5))
         d 
        addChild(block.node)
        textureCount += 1
        introArray.append(block.node)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        touchStart = DispatchTime.now()
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
//        print("entrou up \(getElapsedTime(touchStart: touchStart))")
        if getElapsedTime(touchStart: touchStart) <= 0.15 {
            if !playEnable {
                playEnable = true
            } else {
            print("1 \(didSwipe)")
            if didSwipe == false {
                print("2")
                
                rotateBlock()
            }
            
            didSwipe = false
            }
        }
    }
    
    func dropBlock() {
        
        if currentNode != nil {
            currentNode!.physicsBody?.linearDamping = 0.1
            
        }
    }
    func rotateBlock() {
        if currentNode != nil {
            self.currentNode!.zRotation -= .pi/2
            self.removeChildren(in: [guideRectangle!])
            
            self.guideRectangle = SKShapeNode(rect: CGRect(x: 0 - currentNode!.frame.width / 2, y: -self.size.height/2, width: currentNode!.frame.width, height: self.size.height))
            self.guideRectangle?.zPosition = 1
            self.guideRectangle!.fillColor = .blue
            self.guideRectangle!.alpha = 0.3
            self.guideRectangle?.position.x = currentNode!.position.x
            addChild(guideRectangle!)
        }
        //TODO: testar torque
        
    }
    
    func getElapsedTime(touchStart: DispatchTime) -> Double {
        touchEnd = DispatchTime.now()
        return Double(touchEnd.uptimeNanoseconds - touchStart.uptimeNanoseconds) / 1_000_000_000
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self))
            //seta y position do toque
            //Starta timer
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self))
            //verifica se n foi tap e começa a mover
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self))
            // tap
            // se n for tap verifica y do ultimo toque
            //invalida timer
            
            
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    func checkCollision() {
        
        // verifica se colidiu com outro bloco, cenario ou caiu pra fora
        if self.currentNode != nil {
            
            if (self.currentNode!.physicsBody?.allContactedBodies().description.contains("Polygon"))! || (self.currentNode!.physicsBody?.allContactedBodies().description.contains("Rectangle"))! || (self.currentNode!.physicsBody?.allContactedBodies().description.contains("Compound"))!  {
                
                self.currentNode?.removeAllChildren()
                self.currentNode = nil
                self.isFalling = false
                self.guideRectangle!.removeFromParent()
            }
                
                
            else if self.currentNode!.position.y <= CGFloat(-600) {
//                print("xobla")
                self.currentNode?.removeAllChildren()
                self.removeChildren(in: [self.currentNode!])
                self.currentNode = nil
                self.isFalling = false
                self.guideRectangle!.removeFromParent()
                
            }
            
        }
    }
    
    var beganPosition : CGPoint = .zero
    
    @objc func panGestured(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            
//            print(touchStart)
//            print("entrou began")
            didSwipe = true
            
            beganPosition = currentNode?.position ?? .zero
            
        case .changed:
            if let currentNode = currentNode
            {
                let maxX = self.view!.bounds.width/2 + currentNode.frame.width/2
                let minX = -1 * maxX
                let resultPos = panGesture.translation(in: self.view).x + beganPosition.x// currentNode.position.x
                
                let newPos = round(min(max(minX, resultPos), maxX) / CGFloat(self.grid)) * CGFloat(self.grid)
                
                currentNode.position.x = newPos
                guideRectangle!.position.x = newPos
//                print("entrou changed")
//                if panGesture.translation(in: self.view).y > 100 {
//
//                    dropBlock()
//
//                } else {
//                    let maxX = self.view!.bounds.width/2
//                    let minX = -1 * maxX
//                    let newPos = currentNode!.position.x + (panGesture.velocity(in: nil).x * 0.1)
//
//                    currentNode?.position.x = min(max(minX, newPos), maxX)
//
////
////                    let newPos = currentNode!.position.x //+ (panGesture.translation(in: self.view).x)
////                    let teste = self.view!.bounds.size.width - currentNode!.frame.width
////                    print("teste", teste)
////                    let newPositionX = ( panGesture.translation(in: nil) / CGFloat(self.grid)) * CGFloat(self.grid)
////
////                    let newPositionY = Double(self.currentNode!.position.y)
////
////                    print(newPositionX,  self.view!.bounds.size.width)
////
////                    if newPositionX < self.view!.bounds.size.width - currentNode!.frame.width && newPositionX > self.view!.bounds.size.width / 2 + currentNode!.frame.width {
////                        self.currentNode!.position = CGPoint(x: Double(newPositionX), y: newPositionY)
////                        self.guideRectangle!.position = CGPoint(x: Double(newPositionX), y: Double(self.guideRectangle!.position.y))
////                    }
//
//                }
            }
            
        case .ended:
//            print("entrou ended")
//            print(getElapsedTime(touchStart: touchStart))
            if didSwipe {
                didSwipe = false
            }
            
//            print(panGesture.velocity(in: self.view))
//
//            if panGesture.translation(in: self.view).y > 100 {
//                dropBlock()
//            }
            
        default:
            print("yey")
        }
        
    }
    //    @objc func swipedRight() {
    //        if currentNode != nil {
    //            let newPositionX = (round(Float(currentNode!.position.x + CGFloat(self.grid))/Float(self.grid)) * Float(self.grid))
    //
    //        let newPositionY = Double(self.currentNode!.position.y)
    //        self.currentNode!.position = CGPoint(x: Double(newPositionX), y: newPositionY)
    //        self.guideRectangle!.position = CGPoint(x: Double(newPositionX), y: Double(self.guideRectangle!.position.y))
    //        }
    //    }
    //
    //    @objc func swipedLeft() {
    //        if currentNode != nil {
    //            let newPositionX = (round(Float(currentNode!.position.x - CGFloat(self.grid))/Float(self.grid)) * Float(self.grid))
    //
    //        let newPositionY = Double(self.currentNode!.position.y)
    //        self.currentNode!.position = CGPoint(x: Double(newPositionX), y: newPositionY)
    //        self.guideRectangle!.position = CGPoint(x: Double(newPositionX), y: Double(self.guideRectangle!.position.y))
    //        }
    //    }
    //
    //    @objc func tappedView(_ sender:UITapGestureRecognizer) {
    //
    //
    //        if currentNode != nil {
    //            print("[tappedView] width before rotation \(self.currentNode!.frame.width)")
    //            self.currentNode!.zRotation -= .pi/2
    //            print("[tappedView] height before rotation \(self.currentNode!.frame.width)")
    //            if !rotated {
    //                if self.currentNode!.frame.width / self.currentNode!.frame.height > 1 {
    //                    self.guideRectangle?.xScale = 1 / (self.currentNode!.frame.width / self.currentNode!.frame.height)
    //                    print("[tappedView] Scaling by: \(1 / (self.currentNode!.frame.width / self.currentNode!.frame.height))")
    //                } else{
    //                    self.guideRectangle?.xScale = (self.currentNode!.frame.width / self.currentNode!.frame.height)
    //                    print("[tappedView] Scaling by: \(self.currentNode!.frame.width / self.currentNode!.frame.height))")
    //                }
    //                rotated = true
    //            } else {
    //                if self.currentNode!.frame.height / self.currentNode!.frame.width > 1 {
    //                    self.guideRectangle?.xScale = 1
    //                    print("[tappedView] Scaling by: \(self.currentNode!.frame.height / self.currentNode!.frame.width))")
    //                } else{
    //                    self.guideRectangle?.xScale = 1
    //                    print("[tappedView] Scaling by: \(1 / (self.currentNode!.frame.height / self.currentNode!.frame.width))")
    //                }
    //                rotated = false
    //            }
    //
    //
    //
    //
    //
    //
    //        }
    //    }
    //
    //    @objc func swipedDown() {
    //    if currentNode != nil {
    //        currentNode?.physicsBody?.linearDamping = 0.1
    //    }
    //        print("Down")
    //    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if playEnable {
            baseNode?.physicsBody?.isDynamic = true
            baseNode?.alpha = 1
            if !introArray.isEmpty {
                for i in introArray {
                    i.removeFromParent()
                }
            }
            labelPlay?.removeFromParent()
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
            
        } else {
            baseNode?.alpha = 0
            minTickIntro += 1
            if minTickIntro >= maxTickIntro {
                minTickIntro = 0
                addBlockInSceneIntro()
            }
            
            
        }
        
        
    }
}
