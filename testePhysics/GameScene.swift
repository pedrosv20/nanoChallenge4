//
//  GameScene.swift
//  testePhysics
//
//  Created by Pedro Vargas on 03/03/20.
//  Copyright © 2020 Pedro Vargas. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox

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
    var playEnable: playEnabled = .menu
    
    var baseNode: SKNode?
    var highestY: CGFloat = -600
    
    var minTickIntro = 0
    var maxTickIntro = 15
    
    var introArray: [SKNode] = []
    
    
    
    var lifes = 3
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
    
    var goBackground: SKNode?
    var go_extraLife : SKNode?
    var go_noThanks : SKNode?
    var go_yourScore : SKNode?
    var go_maxScore : SKNode?
    var scoreGameOver : SKLabelNode?
    var maxScoreGameOver : SKLabelNode?
    
    var goBackgroundLite: SKNode?
    var yourScoreBackground: SKNode?
    var maxScoreBackground: SKNode?
    var yourScoreLabel: SKLabelNode?
    var maxScoreLabel: SKLabelNode?
    var gameOverLabel: SKLabelNode?
    var goCloseButton: SKNode?
    var gameCenterButton: SKNode?
    //Sounds
    
    var audioManager :AudioManager?
    
    override func didMove(to view: SKView) {
        //        self.cam = self.camera

        self.camera = self.cam
        
        self.audioManager = AudioManager()
        run(self.audioManager!.bg)
        
        //        self.bgSound = SKAction.playSoundFileNamed("Towers Music.wav", waitForCompletion: true)
        //        run(bgSound!)
        

        setupUI()
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestured))
        panGesture.delegate = self
        self.view?.addGestureRecognizer(panGesture)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipe.delegate = self
        swipe.direction = .down
        self.view?.addGestureRecognizer(swipe)
    }
    
    func vibrate(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
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
        
        labelScore = layerScore?.childNode(withName: "labelScore") as! SKLabelNode
        
        goBackground = (childNode(withName: "go_background")!)
        go_extraLife = goBackground?.childNode(withName: "go_extraLife")
        go_extraLife!.name = "go_extraLife"
        go_noThanks = goBackground?.childNode(withName: "go_noThanks")
        go_noThanks!.name = "go_noThanks.name"
        go_yourScore = goBackground?.childNode(withName: "go_yourScore")
        go_maxScore = goBackground?.childNode(withName: "go_maxScore")
        scoreGameOver = goBackground?.childNode(withName: "scoreGameOver") as! SKLabelNode
        maxScoreGameOver = (goBackground?.childNode(withName: "maxScoreGameOver") as! SKLabelNode)
        
        goBackgroundLite = childNode(withName: "goLite_background")
        yourScoreBackground = goBackgroundLite!.childNode(withName: "yourScoreBackground")
        maxScoreBackground = goBackgroundLite!.childNode(withName: "maxScoreBackground")
        yourScoreLabel = goBackgroundLite!.childNode(withName: "yourScoreLabel") as! SKLabelNode
        gameOverLabel = (goBackgroundLite!.childNode(withName: "gameOverLabel") as! SKLabelNode)
        maxScoreLabel = (goBackgroundLite!.childNode(withName: "maxScoreLabel") as! SKLabelNode)
        goCloseButton = goBackgroundLite!.childNode(withName: "goCloseButton")
        goCloseButton!.name = "goCloseButton"

        gameCenterButton = self.childNode(withName: "gameCenter")
        gameCenterButton!.name = "gameCenter"
        
        
        
        
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
        
        if guideRectangle != nil {
            self.guideRectangle?.removeFromParent()
        }
        guideRectangle = SKShapeNode(rect: CGRect(x: 0 - block.node.size.width / 2,
                                                  y: -self.frame.height/2,
                                                  width: block.node.size.width,
                                                  height: self.frame.height))
        guideRectangle?.zPosition = 1
        guideRectangle!.fillColor = .blue
        guideRectangle!.alpha = 0.3
        guideRectangle?.position.x = self.currentNode!.position.x
        
        
        
        guideRectangle?.removeFromParent()
        self.addChild(self.currentNode!)
        
        self.addChild(self.guideRectangle!)
        
        
//        print("#1 addRec")
        
        
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
        if playEnable == .menu {
            if (playLabel?.contains(pos))! {
                self.cam.position.y = 0
                self.guideRectangle?.removeFromParent()
                playEnable = .play
            }
        }
        
        
        if getElapsedTime(touchStart: touchStart) <= 0.15 {
            
            if playEnable == .play {
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
            guideRectangle?.removeFromParent()
            
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
            let touch:UITouch = touches.first!
            let positionInScene = touch.location(in: self)
            let touchedNodes = self.nodes(at: positionInScene)
            for touch in touchedNodes {
                let touchName = touch.name
//                print(touchName, UserInfo.shared.showRewardedAd)
                if (touchName != nil && touchName!.contains("go_extraLife") ) {
                    self.controller?.showRewardedAd()
                    UserInfo.shared.showRewardedAd = true
                    self.isPaused = true
                    
                }
                else if (touchName != nil && touchName!.contains("go_noThanks")) {
                    UserInfo.shared.showRewardedAd = false
                    self.playEnable = .menu
                    self.isPaused = false
                    
                }
                else if (touchName != nil && touchName!.contains("goCloseButton")) {
                    self.playEnable = .menu
                    self.isPaused = false
                    
                    
                }
                else if (touchName != nil && (touchName?.contains("gameCenter"))!) {
                    GameCenter.shared.showLeaderboard(presentingVC: self.controller!)
                }
            }
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
                
                //Play sound
                run(self.audioManager!.blockTouch)
                
                self.currentNode?.removeAllChildren()
                self.guideRectangle!.removeFromParent()
                self.currentNode = nil
                self.isFalling = false
                
            }
                
                
            else if self.currentNode!.position.y <= CGFloat(-600 + self.cam.position.y) {
                
                if blocksList.contains(currentNode!) {
                    blocksList.remove(at: blocksList.firstIndex(of: self.currentNode!)!)
                }
                
                run(self.audioManager!.blockOut)
                self.vibrate()
                
                self.currentNode?.removeAllChildren()
                self.removeChildren(in: [self.currentNode!])
                self.guideRectangle!.removeFromParent()
                self.currentNode = nil
                self.isFalling = false
                
                lifes -= 1
                
            }
                
            else  {
                for block in blocksList {
                    if block.position.y < -600  {
                        if blocksList.contains(block) {
                            blocksList.remove(at: blocksList.firstIndex(of: block)!)
                        }
                        
                        lifes -= 1

                        run(self.audioManager!.blockOut)
                        self.vibrate()
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
//            print("tey", self.frame.minY + self.frame.height / 3)
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
//                print(block.frame.maxY / 50)
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
        line.lineWidth = 2.0
        line.strokeColor = .yellow
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
        if getLifes() <= 0 {
            //gameOver
            
            heartInGame?.run(SKAction.setTexture(SKTexture(imageNamed: "heart_0")))
            GameCenter.shared.updateScore(with: UserInfo.shared.highScore)
            currentNode?.removeFromParent()
            self.isFalling = false
            
            
            if highScoreLine == nil {
                addLine()
            }
            
            self.isUserInteractionEnabled = false
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (Timer) in
                self.isUserInteractionEnabled = true
            }
            
            for node in blocksList {
                if (node.physicsBody?.velocity.dy)! > CGFloat(0) {
                    node.removeFromParent()
                    blocksList.remove(at: blocksList.firstIndex(of: node)!)
                }
            }
            
            if !UserInfo.shared.showRewardedAd {
                self.playEnable = .gameOverAd
                self.guideRectangle!.removeFromParent()
            } else {
                self.playEnable = .gameOver
                self.guideRectangle!.removeFromParent()
            }
            
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
        if self.children.contains(layerScore!) {
            layerScore?.removeAllChildren()
            layerScore?.removeFromParent()
        }
        if self.children.contains(gameCenterButton!) {
            gameCenterButton?.removeFromParent()
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
        if !self.children.contains(gameCenterButton!) {
            addChild(gameCenterButton!)
        }
        if !self.children.contains(layerScore!) {
            addChild(layerScore!)
            if !layerScore!.children.contains(labelScore!) {
                layerScore!.addChild(labelScore!)
                labelScore!.text = "\(UserInfo.shared.highScore) m"
                print(UserInfo.shared.highScore)
            } else {
                labelScore!.text = "\(UserInfo.shared.highScore) m"
                print(UserInfo.shared.highScore)
            }
        } else {
            labelScore!.text = "\(UserInfo.shared.highScore) m"
            print(UserInfo.shared.highScore)
            }
    }
    
    func checkHighScore() {
        
        if highScoreLine != nil {
            
            if maxY != 0.0 {
                if  maxY! > highScoreLine!.frame.midY {
                    self.highScoreLine!.removeFromParent()
                    self.highScoreLine = nil
                }
            }
            
        }
        
    }
    
    func checkFallingBlocks() {
        for block in blocksList {
            if ((block.physicsBody?.velocity.dy)!) > CGFloat(0.0) {
                block.removeFromParent()
                blocksList.remove(at: blocksList.firstIndex(of: block)!)
            }
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
//        print(UserInfo.shared.showRewardedAd)
        
        
        
        if playEnable == .play { //game
            
            
            UIConfigInGame()
            highScoreLine?.isHidden = false
            if self.guideRectangle != nil && currentNode == nil{
                self.guideRectangle?.removeFromParent()
            }
            if self.children.contains(goBackground!) {
                goBackground?.removeFromParent()
            }
            if self.children.contains(goBackgroundLite!) {
                goBackgroundLite?.removeFromParent()
            }
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
            
        }
        else if playEnable == .menu{
            
            UserInfo.shared.showRewardedAd = false
            self.lifes = 3
            if self.guideRectangle != nil {
                self.guideRectangle?.removeFromParent()
            }
            if self.children.contains(goBackgroundLite!) {
                goBackgroundLite?.removeFromParent()
            }
            if self.children.contains(goBackground!) {
                goBackground?.removeFromParent()
            }
            self.mist?.position.y = -583
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
            clearBlocks()
            self.guideRectangle?.removeAllChildren()
            self.guideRectangle?.removeFromParent()
            //tela inicial
            highScoreLine?.isHidden = true
            
            UIConfigMenus()
            minTickIntro += 1
            if minTickIntro >= maxTickIntro {
                minTickIntro = 0
                addBlockInSceneIntro()
            }
        }
        else if playEnable == .gameOver {
            if self.children.contains(goBackground!) {
                goBackground?.removeFromParent()
            }
            if self.guideRectangle != nil {
                self.guideRectangle?.removeFromParent()
            }
            self.guideRectangle!.removeFromParent()
            if !self.children.contains(goBackgroundLite!) {
                self.addChild(goBackgroundLite!)
                goBackgroundLite?.position.y = 0 + self.cam.position.y
                self.yourScoreLabel?.text = "\(returnScore())m"
                self.maxScoreLabel?.text = "\(UserInfo.shared.highScore)m"
            } else {
                self.yourScoreLabel?.text = "\(returnScore())m"
                self.maxScoreLabel?.text = "\(UserInfo.shared.highScore)m"
            }
            
            
        }
        else if playEnable == .gameOverAd {
            if self.children.contains(goBackgroundLite!) {
                goBackgroundLite?.removeFromParent()
            }
            if self.guideRectangle != nil {
                self.guideRectangle?.removeFromParent()
            }
            self.guideRectangle!.removeFromParent()
            if !self.children.contains(goBackground!) {
                self.addChild(goBackground!)
//                print(goBackground!.position.y, self.cam.position.y)
                goBackground?.position.y = 0 + self.cam.position.y
                self.scoreGameOver?.text = "\(returnScore())m"
                self.maxScoreGameOver?.text = "\(UserInfo.shared.highScore)m"
//                print("ad")
            } else {
                self.scoreGameOver?.text = "\(returnScore())m"
                self.maxScoreGameOver?.text = "\(UserInfo.shared.highScore)m"
            }
        }
    }
}

public enum playEnabled {
    case menu
    case play
    case gameOverAd
    case gameOver
    
}
