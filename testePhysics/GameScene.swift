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
    

    public var controller: GameViewController?
    var node: SKSpriteNode!
    var cam = SKCameraNode()
    var blocksList :[SKNode] = []
    var maxY : CGFloat?
    var distance : CGFloat = 0.0
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
    
    var baseNode: SKNode?
    var highestY: CGFloat = -600
    
    var minTickIntro = 0
    var maxTickIntro = 15
    
    var introArray: [SKNode] = []
    
    
    
    var lifes = 3
//    var lifeInGame: SKLabelNode?
    var heartInGame: SKNode?
    var scoreInGame: SKLabelNode?
    var layerScoreInGame : SKNode?
    
    
    var mist: SKNode?
    var nameLabel: SKNode?
    var playLabel: SKNode?
    var layerScore: SKNode?
    var labelScore: SKLabelNode?
    var beganPosition : CGPoint = .zero
    var highScoreLine: SKShapeNode? = nil

    
    override func didMove(to view: SKView) {
//        self.cam = self.camera
        self.camera = self.cam
        
        
        setupUI()
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestured))
        panGesture.delegate = self
        self.view?.addGestureRecognizer(panGesture)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipe.delegate = self
        swipe.direction = .down
        self.view?.addGestureRecognizer(swipe)
    }
    func setupUI() {
        
        nameLabel = childNode(withName: "nameLabel") as! SKSpriteNode
        
        nameLabel?.zPosition = 2
        
        background = childNode(withName: "background") as! SKSpriteNode
        
        background!.zPosition = 0
        
        baseNode = childNode(withName: "baseNode") as! SKSpriteNode
        
        baseNode!.zPosition = 2
        
        baseNode?.physicsBody?.isDynamic = false
        
        playLabel = (childNode(withName: "playLabel") as! SKSpriteNode)
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.6)
        let fadeOut = SKAction.fadeOut(withDuration: 0.7)
        let sequence  = SKAction.sequence([fadeIn,fadeOut])
        
        playLabel?.run(SKAction.repeatForever(sequence))
        playLabel?.zPosition = 4
        
        layerScore = childNode(withName: "layerScore") as! SKSpriteNode
        
        mist = childNode(withName: "mist") as! SKSpriteNode
        
//        lifeInGame = (childNode(withName: "lifeInGame") as! SKLabelNode)
        heartInGame = (childNode(withName: "heartInGame")!)
        scoreInGame = (childNode(withName: "scoreInGame") as! SKLabelNode)
        layerScoreInGame = (childNode(withName: "layerScoreInGame")!)
    }
    @objc func handleSwipeDown() {
        dropBlock()
        
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }

//    func createLinesGride(){
//        let spaceLines = CGFloat(50/1)
//
//        let screenSize = UIScreen.main.bounds
//        let screenWidth = screenSize.width
////        print("screenWidth: \(screenWidth)")
//        let numberGrids = Int(screenWidth / spaceLines) - 2
////        print("numberGrids: \(numberGrids)")
//
//        //line center
//        let centerLine = self.createLine(x: 0)
//        centerLine.strokeColor = .blue
//        //        addChild(centerLine)
//
//
//        for i in 1...numberGrids{
//            let x = CGFloat(i)*spaceLines
//            addChild(self.createLine(x: x))
//            addChild(self.createLine(x: -x))
//
//        }
//
//    }
    
//    func createLine(x1 : CGFloat, x2 :CGFloat, y1 :CGFloat, y2 :CGFloat) -> SKShapeNode{
//        let line = SKShapeNode()
//        let path = CGMutablePath()
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLines(between: [CGPoint(x: x1, y: y1), CGPoint(x: x2, y: y2)])
//        line.path = path
//        line.strokeColor = .red
//        line.zPosition = 2
//
//        return line
//    }
    
    func addBlockInScene() {
        self.isFalling = true
        let blockElement = pieceArray.randomElement()!
        let blockElementPosition = pieceArray.firstIndex(of: blockElement)!
        let texture = blockElement + "_" + (String((textureCount % 5) + 1))
        let block = builder.createBlock(texture: texture,
                                        path: BlockType.allCases[blockElementPosition])
        
        let xPos = CGFloat.random(in: (self.scene!.position.x - 200) ..< (self.scene!.position.x + 200))
        

        let maxX = self.view!.bounds.width/2 + block.node.size.width/2
        let minX = -1 * maxX
        
        let yPos = 400 +  self.cam.position.y
        let newX = round(min(max(minX, xPos), maxX))
        
        block.node.position = CGPoint(x: newX ,
                                      y: yPos)

        
        self.currentNode = block.node
        
        guideRectangle = SKShapeNode(rect: CGRect(x: 0 - block.node.size.width / 2,
                                                  y: -self.frame.height/2,
                                                  width: block.node.size.width,
                                                  height: self.frame.height))
        guideRectangle?.zPosition = 1
        guideRectangle!.fillColor = .blue
        guideRectangle!.alpha = 0.3
        guideRectangle?.position.x = self.currentNode!.position.x
        
        
        
        self.addChild(self.currentNode!)
        self.addChild(guideRectangle!)
        
        //MARK: ADD ARRAY BLOCKS
//        self.blocksList.append(self.currentNode!)
        
        
        textureCount += 1
        
    }
    
    func addBlockInSceneIntro() {
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
        block.node.run(SKAction.moveTo(y: (self.camera?.position.y)! - 1000, duration: 1))
         
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
                if (playLabel?.contains(pos))! {
                    self.cam.position.y = 0
                    playEnable = true
                }
            } else {
            if didSwipe == false {
                
                
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
    
    func createLine(y : CGFloat) -> SKShapeNode{
        let line = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLines(between: [CGPoint(x: -200, y: y), CGPoint(x: 200, y: y)])
        line.path = path
        line.strokeColor = .red
        line.zPosition = 2
        
        return line
    }
    
    
    func checkCollision() {
        
        // verifica se colidiu com outro bloco, cenario ou caiu pra fora
        if self.currentNode != nil {
            
            if (self.currentNode!.physicsBody?.allContactedBodies().description.contains("Polygon"))! || (self.currentNode!.physicsBody?.allContactedBodies().description.contains("Rectangle"))! || (self.currentNode!.physicsBody?.allContactedBodies().description.contains("Compound"))!  {
                
                //MARK: ADD ARRAY BLOCKS
                self.currentNode?.physicsBody?.linearDamping = 6
                self.blocksList.append(self.currentNode!)
                
                //MARK: ADD LINHA
//                self.addChild(self.createLine(y: (self.currentNode?.frame.maxY)!))
                
                self.currentNode?.removeAllChildren()
                self.currentNode = nil
                self.isFalling = false
                self.guideRectangle!.removeFromParent()
            }
                
                
            else if self.currentNode!.position.y <= CGFloat(-600 + self.cam.position.y) {
                
                if blocksList.contains(currentNode!) {
                    blocksList.remove(at: blocksList.firstIndex(of: self.currentNode!)!)
                }
                
                
                self.currentNode?.removeAllChildren()
                self.removeChildren(in: [self.currentNode!])
                self.currentNode = nil
                self.isFalling = false
                self.guideRectangle!.removeFromParent()
                lifes -= 1
                
            }
                
            else  {
                for block in blocksList {
                    if block.position.y < -600 {
                        if blocksList.contains(block) {
                            blocksList.remove(at: blocksList.firstIndex(of: block)!)
                        }
                        lifes -= 1
//                        self.guideRectangle!.removeFromParent()
                    }
                }
            }
            
        }
    }
    
    //MARK: UPDATE CAMERA
    func updateCamera(){
        
        let roler :CGFloat = self.frame.minY + (self.frame.height/3)
        
            if(self.maxY != nil){
                var positions :[CGFloat] = [roler]
                for block in self.blocksList{

                    positions.append(block.position.y + (block.frame.height/2))
//                    positions.append(block.frame.maxY)
                    
                }
                self.maxY = positions.max()
            }else{
                print("tey", self.frame.minY + self.frame.height / 3)
                self.maxY = roler
            }
        
        if(self.maxY! > roler){
            self.distance = self.maxY! - roler
            
            
        }
        
        
        
    }
    
    @objc func panGestured(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            

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

            }
            
        case .ended:

            if didSwipe {
                didSwipe = false
            }
            

            
        default:
            print("yey")
        }
        
    }
    
    func returnScore() -> Int{
        
//        var param = self.view!.frame.size.height / 10
        
        
        for block in blocksList {
            if block.frame.maxY / 50 > highestY {
                print(block.frame.maxY / 50)
                highestY = block.frame.maxY / 50
                
            }
        }
        if Int(highestY + 12) < 0 {
            return 0
        }
        return Int(highestY + 12)
    }
    
    func createLine(x1 : CGFloat, x2 :CGFloat, y1 :CGFloat, y2 :CGFloat) -> SKShapeNode{
        let line = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLines(between: [CGPoint(x: x1, y: y1), CGPoint(x: x2, y: y2)])
        line.path = path
        line.strokeColor = .red
        line.zPosition = 2

        return line
    }
    
    func addLine() {
        let linePositionY = (UserInfo.shared.highScore - 12) * 50
        let line = createLine(x1: self.frame.minX, x2: self.frame.maxX, y1: CGFloat(linePositionY), y2: CGFloat(linePositionY))
        line.name = "line"
        for children in self.children {
            if children.name == "line" {
                children.removeFromParent()
            }
        }
        highScoreLine = line
        addChild(highScoreLine!)
    }
    
    
    func getLifes() -> Int {
        return lifes
    }
    
    func gameOver() {
        if getLifes() <= 0 { //gameOver
            if highScoreLine == nil {
                addLine()
            }
            self.mist?.position.y = -583

            if self.currentNode != nil {
                currentNode?.removeFromParent()
            }
            if self.guideRectangle != nil {
                guideRectangle?.removeFromParent()
            }
            self.playEnable = false
            lifes = 3
            self.isFalling = false
            if !blocksList.isEmpty {
                for block in blocksList {
                    block.removeFromParent()
                    
                }
                blocksList.removeAll()
            }
            
            
            maxY = 0
            highestY = -600
            distance = 0.0
            self.cam.position.y = 0
            self.isUserInteractionEnabled = false
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (Timer) in
                self.isUserInteractionEnabled = true
            }
//            self.controller?.showRewardedAd()
            clearBlocks()

            
        }
    }
    
    func clearBlocks() {
        if !blocksList.isEmpty {
            for block in blocksList {
                block.removeFromParent()
            }
            blocksList.removeAll()

        }
    }
    
    func cameraObserver() {
        self.updateCamera()

        if(self.maxY != nil){

            if((self.cam.position.y) < self.distance){
                //subir camera
                self.cam.position.y += 1
                if(self.cam.position.y > self.distance){
                    self.cam.position.y = self.distance
                }
            }else{
                self.cam.position.y -= 1
                if(self.cam.position.y < self.distance){
                    self.cam.position.y = self.distance
                }
            }
            if guideRectangle != nil {
                guideRectangle!.position.y = (self.cam.position.y)
                self.mist?.position.y = self.cam.position.y - self.frame.height / 2 + 80
//                self.lifeInGame!.position.y = self.cam.position.y + self.frame.height / 2 - 100
                self.heartInGame!.position.y = self.cam.position.y + self.frame.height / 2 - 100
                self.scoreInGame!.position.y = self.cam.position.y + self.frame.height / 2 - 120
                self.layerScoreInGame?.position.y = self.cam.position.y + self.frame.height / 2 - 100
                
            }
        }
    }
    
    func UIConfigInGame() {
        if !introArray.isEmpty {
            for i in introArray {
                i.removeFromParent()
            }
        }
//        if !self.children.contains(lifeInGame!) {
//            self.addChild(lifeInGame!)
//        }
        if !self.children.contains(heartInGame!) {
            self.addChild(heartInGame!)
        }
        if !self.children.contains(scoreInGame!) {
            self.addChild(scoreInGame!)
        }
        if !self.children.contains(layerScoreInGame!) {
            self.addChild(layerScoreInGame!)
        }
        
//        lifeInGame?.text = "life: \(getLifes())"
        heartInGame?.run(SKAction.setTexture(SKTexture(imageNamed: "heart_\(getLifes())")))
        scoreInGame?.text = "\(returnScore())m"
        
//        lifeInGame?.zPosition = 2
        heartInGame?.zPosition = 2
        layerScoreInGame?.zPosition = 2
        scoreInGame?.zPosition = 3
        
        baseNode?.alpha = 1
        baseNode?.zPosition = 1
        playLabel?.removeFromParent()
        nameLabel?.removeFromParent()
        layerScore?.removeFromParent()
        self.mist?.zPosition  = 3
    }
    
    func UIConfigMenus() {
        if self.children.contains(scoreInGame!) {
            scoreInGame!.removeFromParent()
        }
        if self.children.contains(layerScoreInGame!) {
            layerScoreInGame!.removeFromParent()
        }
//        if self.children.contains(lifeInGame!) {
//            lifeInGame?.removeFromParent()
//        }
        if self.children.contains(heartInGame!) {
            heartInGame?.removeFromParent()
        }
        
        
        baseNode?.alpha = 0
        
        self.cam.position.y = 0
        self.mist?.zPosition  = 1
        if !self.children.contains(playLabel!) {
            self.addChild(playLabel!)
        }
        if !self.children.contains(nameLabel!) {
            addChild(nameLabel!)
        }
        if !self.children.contains(layerScore!) {
            addChild(layerScore!)
            labelScore = (layerScore!.children.first as! SKLabelNode)
            layerScore?.zPosition = 2
            print("carregou labelScore")
            labelScore!.text = "\(UserInfo.shared.highScore)m"
            labelScore?.zPosition = 3

        }
    }
    
    func checkHighScore() {
        
        if highScoreLine != nil {
            print("#1", maxY!, highScoreLine!.frame.midY)
            if maxY != 0.0 {
                if  maxY! > highScoreLine!.frame.midY {
                    self.highScoreLine!.removeFromParent()
                    self.highScoreLine = nil
                }
            }
            
        }
            
    }
    
    override func update(_ currentTime: TimeInterval) {
        if playEnable { //game
            
            UIConfigInGame()
            highScoreLine?.isHidden = false
            
            checkHighScore()
            minTick += 1
            if minTick >= maxTick {
                if !isFalling {
                    addBlockInScene()
                }
                minTick = 0
                if !(UserInfo.shared.highScore > returnScore()) {
                    UserInfo.shared.highScore = returnScore()
                }
            }
            if currentNode?.physicsBody != nil {
                checkCollision()
            }
            cameraObserver()
            gameOver()
        } else { //tela inicial
            highScoreLine?.isHidden = true
            UIConfigMenus()
            minTickIntro += 1
            if minTickIntro >= maxTickIntro {
                minTickIntro = 0
                addBlockInSceneIntro()
            }
        }
    }
}
