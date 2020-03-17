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

class GameViewController: UIViewController, GADInterstitialDelegate{

    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
        [ "6f0766e55539d67ae625c3ed00af5546" ]
        interstitial = createAndLoadInterstitial()
        let request = GADRequest()
        interstitial.load(request)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                if let gameScene = scene as? GameScene {
                    gameScene.controller = self
                }
                // Present the scene
                view.presentScene(scene)
            }

            view.ignoresSiblingOrder = true
            
        }
    }
    

    func createAndLoadInterstitial() -> GADInterstitial {
      var interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
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
