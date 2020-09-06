//
//  GameScene.swift
//  Joker Way
//
//  Created by  Developer on 8/28/20.
//  Copyright © 2020 kharseko. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    var backgroundNode: SKSpriteNode!
    var jokerNode: SKSpriteNode!
    var playButtonNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        playButtonNode = self.childNode(withName: "playBtn") as? SKSpriteNode
        jokerNode = self.childNode(withName: "joker") as? SKSpriteNode
        backgroundNode = self.childNode(withName: "bg") as? SKSpriteNode
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

        if let name = touchedNode.name, name == "playBtn" {
            presentGameScene()
        }
    }
}

extension MenuScene {
    
    func setupUI() {
        jokerNode.position = CGPoint(x: 0, y: 80)
        jokerNode.size = CGSize(width: self.size.width * 0.9,
                                height: self.size.width * 0.9 * jokerNode.texture!.size().height / jokerNode.texture!.size().width)
        
        backgroundNode.size = self.size
        backgroundNode.position = CGPoint(x: 0, y: 0)
    }
    
    func presentGameScene() {
        let nextScene = GameScene(fileNamed: "GameScene")
        nextScene?.scaleMode = .aspectFill
        self.view?.presentScene(nextScene!, transition: SKTransition.fade(withDuration: 0.5))
        self.removeFromParent()
    }
}
