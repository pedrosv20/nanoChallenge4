//
//  GameViewController.swift
//  testePhysics
//
//  Created by Pedro Vargas on 03/03/20.
//  Copyright © 2020 Pedro Vargas. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import GameKit
import AVKit


class GameViewController: UIViewController, GADInterstitialDelegate, GADRewardedAdDelegate{

    
    var gameScene: GameScene!
    var interstitial: GADInterstitial!
    let leaderboardId = "com.PedroVargas.HighScore"
    var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rewardedAd = createAndLoadRewardedAd()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "6f0766e55539d67ae625c3ed00af5546", "7b5dc55f3972c13bc47d8466bb6fe1cc" ]
        
        GameCenter.shared.authenticateLocalPlayer(presentingVC: self)
        
        if UserInfo.shared.highScore != 0 {
            GameCenter.shared.updateScore(with: UserInfo.shared.highScore)
        }
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                if let gameScene = scene as? GameScene {
                    self.gameScene = gameScene
                    self.gameScene.controller = self
                }
                // Present the scene
                view.presentScene(scene)
            }

            view.ignoresSiblingOrder = true
            
        }
    }
    //teste ad ca-app-pub-3940256099942544/1712485313
    func createAndLoadRewardedAd() -> GADRewardedAd {
      rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-9555319833753210/6124335048")
      rewardedAd?.load(GADRequest()) { error in
        if let error = error {
          print("Loading failed: \(error)")
            UserInfo.shared.canShowAd = false
        } else {
          print("Loading Succeeded")
            UserInfo.shared.canShowAd = true
        }
      }
      return rewardedAd!
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
      print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        self.gameScene.checkFallingBlocks()
        self.gameScene.lifes = 1
        UserInfo.shared.showRewardedAd = false
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad dismissed.")
        self.rewardedAd = createAndLoadRewardedAd()
        if self.gameScene.lifes  < 1 {
            self.gameScene.gameState = .menu
            UserInfo.shared.showRewardedAd = false
            self.gameScene.goBackground?.removeFromParent()
        } else {
            UserInfo.shared.showRewardedAd = true
            self.gameScene.gameState = .play
            UserInfo.shared.mataTudo = true
        }
        self.gameScene.audioPlayer.play(music: Audio.MusicFiles.background)
    }
    
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad presented.")
    }

    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
      print("Rewarded ad failed to present.")
    }
    
    func showRewardedAd() {
        if rewardedAd?.isReady == true {
           rewardedAd?.present(fromRootViewController: self, delegate:self)
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.all
    }
    
}

