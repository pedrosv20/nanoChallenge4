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
import AVKit

class GameScene: SKScene, UIGestureRecognizerDelegate {
    
    public var controller: GameViewController?
    var node: SKSpriteNode!
    var cam = SKCameraNode()
    var blocksList: [SKNode] = []
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
    var gameState: gameStates = .menu
    
    var baseNode: SKNode?
    var highestY: CGFloat = -600
    
    var minTickIntro = 0
    var maxTickIntro = 15
    
    var introArray: [SKNode] = []
    
    var lifes = 3
    //pause
    var heartInGame: SKNode?
    var scoreInGame: SKLabelNode?
    var layerScoreInGame : SKNode?
    
    var mist: SKNode?
    var nameLabel: SKNode?
    var playLabel: SKNode?
    var layerScore: SKNode?
    var labelScore: SKLabelNode?
    var beganPosition : CGPoint = .zero
    
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
    var goCloseButton: SKNode?
    var gameCenterButton: SKNode?
    var highScoreLine: SKNode?
    let audioPlayer = AudioPlayerImpl()
    
    var tutorialNode: SKNode?
    var tutorialNodeFirstPosition: CGPoint?
    
    var addedHighScore = false
    var beatedHighScore = false
//    var pauseButton: SKNode?
    //load tutorial
    var lastStableTower: [SKNode] = []
    var recreatedTower = false
    var totalValueOfMovement: Double = 0
    var stabilized = true
    
    override func didMove(to view: SKView) {
        audioPlayer.play(music: Audio.MusicFiles.background)
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
    
    func vibrate(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    func setupUI() {
        highScoreLine = childNode(withName: "highScoreLine") as! SKSpriteNode
        setHighScorePosition()
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
        //pause
        heartInGame = (childNode(withName: "heartInGame")!)
//        pauseButton = (childNode(withName: "pauseButton")! as! SKSpriteNode)
//        pauseButton!.name = "pauseButton"
        scoreInGame = (childNode(withName: "scoreInGame") as! SKLabelNode)
        layerScoreInGame = (childNode(withName: "layerScoreInGame")!)
        labelScore = (layerScore?.childNode(withName: "labelScore") as! SKLabelNode)
        goBackground = (childNode(withName: "go_background")!)
        go_extraLife = goBackground?.childNode(withName: "go_extraLife")
        go_extraLife!.name = "go_extraLife"
        go_noThanks = goBackground?.childNode(withName: "go_noThanks")
        go_noThanks!.name = "go_noThanks.name"
        go_yourScore = goBackground?.childNode(withName: "go_yourScore")
        go_maxScore = goBackground?.childNode(withName: "go_maxScore")
        scoreGameOver = (goBackground?.childNode(withName: "scoreGameOver") as! SKLabelNode)
        maxScoreGameOver = (goBackground?.childNode(withName: "maxScoreGameOver") as! SKLabelNode)
        goBackgroundLite = childNode(withName: "goLite_background")
        yourScoreBackground = goBackgroundLite!.childNode(withName: "yourScoreBackground")
        maxScoreBackground = goBackgroundLite!.childNode(withName: "maxScoreBackground")
        yourScoreLabel = (goBackgroundLite!.childNode(withName: "yourScoreLabel") as! SKLabelNode)
        maxScoreLabel = (goBackgroundLite!.childNode(withName: "maxScoreLabel") as! SKLabelNode)
        goCloseButton = goBackgroundLite!.childNode(withName: "goCloseButton")
        goCloseButton!.name = "goCloseButton"
        gameCenterButton = self.childNode(withName: "gameCenter")
        gameCenterButton!.name = "gameCenter"
        //load tutorial
        
        tutorialNode = (childNode(withName: "tutorialNode") as! SKSpriteNode)
        tutorialNodeFirstPosition = tutorialNode?.position
    }
    
    @objc func handleSwipeDown() {
        dropBlock()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
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
        let yPos = 500 +  self.cam.position.y
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
        textureCount += 1
    }
    
    func addBlockInSceneIntro() {
        let blockElement = pieceArray.randomElement()!
        let blockElementPosition = pieceArray.firstIndex(of: blockElement)!
        let texture = blockElement + "_" + (String((textureCount % 5) + 1))
        let block = builder.createBlock(texture: texture, path: BlockType.allCases[blockElementPosition])
        let xPos = CGFloat.random(in: (self.scene!.position.x - 200) ..< (self.scene!.position.x + 200))
        let maxX = self.view!.bounds.width/2 + block.node.size.width/2
        let minX = -1 * maxX
        block.node.position = CGPoint(x: round(min(max(minX, xPos), maxX)), y: 600)
        block.node.physicsBody = nil
        block.node.run(SKAction.moveTo(y: (self.camera?.position.y)! - 1000, duration: 1))
        addChild(block.node)
        textureCount += 1
        introArray.append(block.node)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        touchStart = DispatchTime.now()
    }
    
    func touchMoved(toPoint pos : CGPoint) {}
    
    func touchUp(atPoint pos : CGPoint) {
        if gameState == .menu {
            if (playLabel?.contains(pos))! {
                self.cam.position.y = 0
                self.guideRectangle?.removeFromParent()
                gameState = .play
            }
        }
        if getElapsedTime(touchStart: touchStart) <= 0.15 {
            if gameState == .play {
//                if (pauseButton?.contains(pos))! {
//                    self.isPaused.toggle()
//                }
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
            currentNode?.physicsBody?.mass = 0.01
            
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {for t in touches { self.touchDown(atPoint: t.location(in: self))}}
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {for t in touches { self.touchMoved(toPoint: t.location(in: self))}}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self))
            let touch:UITouch = touches.first!
            let positionInScene = touch.location(in: self)
            let touchedNodes = self.nodes(at: positionInScene)
            for touch in touchedNodes {
                let touchName = touch.name
                //                print(touchName, UserInfo.shared.showRewardedAd)
                if (touchName != nil && touchName!.contains("go_extraLife") && UserInfo.shared.canShowAd) {
                    self.controller?.showRewardedAd()
                    audioPlayer.pause(music: Audio.MusicFiles.background)
                    UserInfo.shared.showRewardedAd = true
                }
                else if (touchName != nil && touchName!.contains("go_noThanks")) {
                    UserInfo.shared.showRewardedAd = false
                    self.gameState = .menu
                }
                else if (touchName != nil && touchName!.contains("goCloseButton")) {
                    self.gameState = .menu
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
    
    func checkCollision() {
        
        // verifica se col
        if self.currentNode != nil {
            
            if (self.currentNode!.physicsBody?.allContactedBodies().description.contains("Polygon"))! || (self.currentNode!.physicsBody?.allContactedBodies().description.contains("Rectangle"))! || (self.currentNode!.physicsBody?.allContactedBodies().description.contains("Compound"))!  {
                let dx = (self.currentNode!.physicsBody?.velocity.dx)! * (self.currentNode!.physicsBody?.velocity.dx)!
                let dy = (self.currentNode!.physicsBody?.velocity.dy)! * (self.currentNode!.physicsBody?.velocity.dy)!
                
                let result = Double(dx + dy)
                let vetorVelocity = sqrt(result)

                if vetorVelocity < 0.01 {
                    let blockHeight = Int(currentNode!.frame.maxY / 50) + 12
                    print("jonas", blockHeight)
                    if blockHeight < 0 {
                        currentNode!.physicsBody?.mass = 1
                    } else if Int(blockHeight / 10) >= 0 {
                        currentNode!.physicsBody?.mass = CGFloat(100 - blockHeight * 10)
                    }
                }
                
                
                //arrayAux
                //MARK: ADD ARRAY BLOCKS
                self.currentNode?.physicsBody?.linearDamping = 6
                self.blocksList.append(self.currentNode!)
                //faz media se der boa arrayEstavel, se n arrayEstavel = arrayAux

                
                
                currentNode?.physicsBody?.mass = 1
                
                //MARK: ADD LINHA
                audioPlayer.play(effect: Audio.EffectFiles.blockTouch)
                self.currentNode?.removeAllChildren()
                self.guideRectangle!.removeFromParent()
                self.currentNode = nil
                self.isFalling = false
                
            }
            else if self.currentNode!.position.y <= CGFloat(-600) {
                if blocksList.contains(currentNode!) {
                    blocksList.remove(at: blocksList.firstIndex(of: self.currentNode!)!)
                }
                audioPlayer.play(effect: Audio.EffectFiles.blockOut)
                self.vibrate()
                self.currentNode?.removeAllChildren()
                self.removeChildren(in: [self.currentNode!])
                self.guideRectangle!.removeFromParent()
                self.currentNode = nil
                self.isFalling = false
                if !UserInfo.shared.mataTudo {
                    lifes -= 1
                }
            }
            else  {
                for block in blocksList {
                    let maxX = self.frame.width / 2 + block.frame.width / 2
                    let minX = -1 * maxX
                    if block.position.y < -600  || block.position.x > maxX || block.position.x < minX {
                        if blocksList.contains(block) {
                            blocksList.remove(at: blocksList.firstIndex(of: block)!)
                        }
//                        print("removeu blovo em posicao", block.position, self.frame.size)
                        block.removeFromParent()
                        if !UserInfo.shared.mataTudo {
                            
                            lifes -= 1
                        }
                        audioPlayer.play(effect: Audio.EffectFiles.blockOut)
                        self.vibrate()
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
            }
            self.maxY = positions.max()
        }else{
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
    
    func returnScore() -> Int {
        for block in blocksList {
//            print(block.)
            if block.frame.maxY / 50 > highestY {
                highestY = block.frame.maxY / 50
                print("tey", highestY, block.frame.maxY, block.name, block.position.y)
            }
        }
        if highestY.isInfinite {
            return 0
        }
        if Int(highestY + 12) < 0 {
            return 0
        }
        return Int(highestY + 12)
    }
    
    func setHighScorePosition() {
        if UserInfo.shared.highScore > 12 {
            let linePositionY = (UserInfo.shared.highScore - 12) * 50
            highScoreLine!.position.y = CGFloat(linePositionY)
            highScoreLine!.name = "line"
        }
        
    }
    
    func getLifes() -> Int {
        return lifes
    }
    
    func gameOver() {
        if getLifes() <= 0 {
            heartInGame?.run(SKAction.setTexture(SKTexture(imageNamed: "heart_0")))
            GameCenter.shared.updateScore(with: UserInfo.shared.highScore)
            currentNode?.removeFromParent()
            self.isFalling = false
            self.isUserInteractionEnabled = false
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (Timer) in
                self.isUserInteractionEnabled = true
            }
            if !UserInfo.shared.showRewardedAd {
                self.gameState = .gameOverAd
                self.guideRectangle!.removeFromParent()
            } else {
                self.gameState = .gameOver
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
                self.cam.position.y += 1
                if(self.cam.position.y > self.distance){
                    self.cam.position.y = self.distance
                }
            }else{
                self.cam.position.y -= 10
                if(self.cam.position.y < self.distance){
                    self.cam.position.y = self.distance
                }
            }
            if guideRectangle != nil {
                guideRectangle!.position.y = (self.cam.position.y)
                self.mist?.position.y = self.cam.position.y - self.frame.height / 2 + 80
                //pause
                self.heartInGame!.position.y = self.cam.position.y + self.frame.height / 2 - 100
//                self.pauseButton!.position.y = self.cam.position.y + self.frame.height / 2 - 100
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
        if !self.children.contains(heartInGame!) {
            self.addChild(heartInGame!)
        }
//        if !self.children.contains(pauseButton!) {
//            self.addChild(pauseButton!)
//        }
        
        //pause
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
        heartInGame?.run(SKAction.setTexture(SKTexture(imageNamed: "heart_\(getLifes())")))
        scoreInGame?.text = "\(returnScore()) m"
        heartInGame?.zPosition = 2
//        pauseButton?.zPosition = 2
        //pause
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
//        if self.children.contains(pauseButton!) {
//            pauseButton?.removeFromParent()
//        }
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
//                print(UserInfo.shared.highScore)
            } else {
                labelScore!.text = "\(UserInfo.shared.highScore) m"
//                print(UserInfo.shared.highScore)
            }
        } else {
            labelScore!.text = "\(UserInfo.shared.highScore) m"
//            print(UserInfo.shared.highScore)
        }
    }
    
    func checkHighScore() {
        if beatedHighScore {
            return
        }
        if maxY != 0.0 {
            if  maxY! > highScoreLine!.position.y {
                self.highScoreLine?.removeFromParent()
                audioPlayer.play(effect: Audio.EffectFiles.newRecord)
                beatedHighScore = true
            }
        }
    }
    
    func checkFallingBlocks() {
        for block in blocksList {
            let maxX = self.frame.width / 2 + block.frame.width
            let minX = -1 * maxX
            if block.position.y < -600 || block.position.x > maxX || block.position.x < minX{
//                print("existe", block.position)
                block.removeFromParent()
                blocksList.remove(at: blocksList.firstIndex(of: block)!)
            }
        }
    }
    
    func changeBlockMassByHeight() {
        for block in blocksList {
//            let dx = (block.physicsBody?.velocity.dx)! * (block.cphysicsBody?.velocity.dx)!
//            let dy = (block.physicsBody?.velocity.dy)! * (block.physicsBody?.velocity.dy)!
//            let result = Double(dx + dy)
//            let vetorVelocity = sqrt(result)
//
//            if vetorVelocity < 0.01 {
//                let blockHeight = Int(block.frame.maxY / 50) + 12
//                print("jonas", blockHeight)
//                if blockHeight < 0 {
//                    block.physicsBody?.mass = 1
//                } else if Int(blockHeight / 10) >= 0 {
//                    block.physicsBody?.mass = CGFloat(100 - blockHeight * 10)
//                }
//            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if gameState == .play { //game
//            for block in blocksList {
                
//                let dx = (block.physicsBody?.velocity.dx)! * (block.physicsBody?.velocity.dx)!
//                let dy = (block.physicsBody?.velocity.dy)! * (block.physicsBody?.velocity.dy)!
//                let result = Double(dx + dy)
//                let vetorVelocity = sqrt(result)
//                let vetorVelocity = block.physicsBody?.angularVelocity
//                totalValueOfMovement += Double(vetorVelocity!)
//            }
//            let averageMovement = totalValueOfMovement / Double(blocksList.count)
//            print("avg", averageMovement)
//            if abs(averageMovement) < 0.001 && stabilized{
//                print("avg salvou torre")
//                lastStableTower = blocksList
//            } else {
//                print("avg nao salvou")
//            }
//            totalValueOfMovement = 0.0
            
            if !addedHighScore {
                if !self.children.contains(highScoreLine!) {
                    addChild(highScoreLine!)
                }
                setHighScorePosition()
                addedHighScore = true
            }

            self.highScoreLine?.isHidden = false
            UIConfigInGame()
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
                if UserInfo.shared.mataTudo {
                    Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (Timer) in
                        UserInfo.shared.mataTudo = false
                    }
                }
                checkCollision()
            }
            gameOver()
            cameraObserver()
        }
        else if gameState == .menu{
            stabilized = true
            recreatedTower = false
            beatedHighScore = false
            addedHighScore = false
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
            highScoreLine?.isHidden = true
            UIConfigMenus()
            minTickIntro += 1
            if minTickIntro >= maxTickIntro {
                minTickIntro = 0
                addBlockInSceneIntro()
            }
        }
        else if gameState == .gameOver {
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
                self.yourScoreLabel?.text = "\(returnScore()) m"
                self.maxScoreLabel?.text = "\(UserInfo.shared.highScore)m"
            } else {
                self.yourScoreLabel?.text = "\(returnScore()) m"
                self.maxScoreLabel?.text = "\(UserInfo.shared.highScore)m"
            }
            highScoreLine?.isHidden = true
        }
        else if gameState == .gameOverAd {
            
            cameraObserver()
            if !recreatedTower {
                checkFallingBlocks()
                for i in blocksList {
                    i.removeFromParent()
                }
                blocksList.removeAll()
                print("jonaaas", lastStableTower.count)
                for i in lastStableTower {
                    blocksList.append(i)
                    
                    addChild(i)
                    i.zPosition = 4
                    print(i.position.y)
                }
                recreatedTower = true
            }
            if self.children.contains(goBackgroundLite!) {
                goBackgroundLite?.removeFromParent()
            }
            if self.guideRectangle != nil {
                self.guideRectangle?.removeFromParent()
            }
            self.guideRectangle!.removeFromParent()
            if !self.children.contains(goBackground!) {
                self.addChild(goBackground!)
                goBackground?.position.y = 0 + self.cam.position.y
                self.scoreGameOver?.text = "\(returnScore()) m"
                self.maxScoreGameOver?.text = "\(UserInfo.shared.highScore)m"
            } else {
                goBackground?.position.y = 0 + self.cam.position.y
                self.scoreGameOver?.text = "\(returnScore()) m"
                self.maxScoreGameOver?.text = "\(UserInfo.shared.highScore)m"
            }
            if !UserInfo.shared.canShowAd {
                self.go_extraLife?.alpha = 0.5
            } else {
                self.go_extraLife!.alpha = 1
            }
            highScoreLine?.isHidden = true
        }
//        else if gameState == .tutorial {
//
//            //////////////////////////////////////////////////////SWIPE LADOS/////////////////////////////////////////////////////////////////
//            minTick += 1
//
//            if minTick >= maxTick {
//                minTick = 0
//                let swipeLeft = SKAction.moveTo(x: tutorialNodeFirstPosition!.x - 100, duration: 0.5)
//                let swipeToZero = SKAction.moveTo(x: tutorialNodeFirstPosition!.x + 100, duration: 0.5)
//                let sequence = SKAction.sequence([swipeLeft,swipeToZero])
//                tutorialNode?.run(SKAction.repeatForever(sequence))
//                if didSwipe {
//                    tutorialNode?.removeAllActions()
//                    //state == swipeDown
//                    gameState = .menu
//                }
//            }
//            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//        }
    }
}

public enum gameStates {
    case menu
    case play
    case gameOverAd
    case gameOver
    case tutorial
}

public enum tutorialStates {
    case swipeHorizontal
    case swipeDown
    case tap
}

