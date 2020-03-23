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

class GameViewController: UIViewController, GADInterstitialDelegate, GADRewardBasedVideoAdDelegate{


    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        
    }
    
    var gameScene: GameScene!
    var interstitial: GADInterstitial!
//    var gcEnabled = Bool()
//    var gcDefaultLeaderBoard = String()
    
    var score = 0
    
    let leaderboardId = "com.PedroVargas.HighScore"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        authenticateLocalPlayer()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
        withAdUnitID: "ca-app-pub-9555319833753210/6124335048")
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
        [ "6f0766e55539d67ae625c3ed00af5546" ]
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        interstitial = createAndLoadInterstitial()
        let request = GADRequest()
        interstitial.load(request)
        GameCenter.shared.authenticateLocalPlayer(presentingVC: self)
        
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
    
//   func authenticateLocalPlayer() {
//    let localPlayer: GKLocalPlayer = GKLocalPlayer.local
//
//        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
//            if((ViewController) != nil) {
//                // 1. Show login if player is not logged in
//                self.present(ViewController!, animated: true, completion: nil)
//            } else if (localPlayer.isAuthenticated) {
//                // 2. Player is already authenticated & logged in, load game center
//                self.gcEnabled = true
//
//                // Get the default leaderboard ID
//                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
//                    if error != nil { print(error)
//                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
//                })
//
//            } else {
//                // 3. Game center is not enabled on the users device
//                self.gcEnabled = false
//                print("Local player could not be authenticated!")
//                print(error)
//            }
//        }
//    }
//
//    func openGameCenter() {
//        let gcVC = GKGameCenterViewController()
//        gcVC.gameCenterDelegate = self
//        gcVC.viewState = .leaderboards
//        gcVC.leaderboardIdentifier = leaderboardId
//        present(gcVC, animated: true, completion: nil)
//    }
//
//    public func addValue(score: Int) {
//           let bestScoreInt = GKScore(leaderboardIdentifier: leaderboardId)
//           bestScoreInt.value = Int64(score)
//        print(bestScoreInt.value)
//           GKScore.report([bestScoreInt]) { (error) in
//               if error != nil {
//                   print(error!.localizedDescription)
//               } else {
//                   print("Best Score submitted to your Leaderboard!")
//               }
//           }
//    }

    func createAndLoadInterstitial() -> GADInterstitial {
      var interstitial = GADInterstitial(adUnitID: "ca-app-pub-9555319833753210/2323894677")
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }


    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        print("saiu")
    }
    
    func showAd() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
        didRewardUserWith reward: GADAdReward) {
      print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        self.gameScene.checkFallingBlocks()
        self.gameScene.lifes = 1
        UserInfo.shared.showRewardedAd = false
    }

    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
      print("Reward based video ad is received.")
    }

    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Opened reward based video ad.")
        
    }

    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad started playing.")
    }

    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad has completed.")
        
    }

    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("TEYQUETINHO")
        
      GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
      withAdUnitID: "ca-app-pub-9555319833753210/6124335048")
        
        if self.gameScene.lifes  < 1 {
            self.gameScene.playEnable = .menu
            UserInfo.shared.showRewardedAd = false
            self.gameScene.goBackground?.removeFromParent()
        } else {
            UserInfo.shared.showRewardedAd = true
            self.gameScene.playEnable = .play
        }
        self.gameScene.isPaused = false
        
        
    }

    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad will leave application.")
    }

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
        didFailToLoadWithError error: Error) {
      print("Reward based video ad failed to load.")
    }
    
    func showRewardedAd() {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
          GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
