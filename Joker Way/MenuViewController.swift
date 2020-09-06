//
//  GameViewController.swift
//  Joker Way
//
//  Created by  Developer on 8/28/20.
//  Copyright © 2020 kharseko. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                // Present the scene
                view.presentScene(scene)
            }
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
