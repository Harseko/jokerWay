//
//  GameScene.swift
//  Joker Way
//
//  Created by  Developer on 8/28/20.
//  Copyright © 2020 kharseko. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var pauseNode: SKNode!
    private var backgroundSprite: SKSpriteNode!
    private var jokerSprite: SKSpriteNode!
    private var level: Level = Level()
    private var comet: Comet!
    private var blocks: [Block] = []

    private let swipeRightRec = UISwipeGestureRecognizer()
    private let swipeLeftRec = UISwipeGestureRecognizer()
    private let swipeUpRec = UISwipeGestureRecognizer()
    private let swipeDownRec = UISwipeGestureRecognizer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    override init() {
        super.init()
        
        setup()
    }

    override init(size: CGSize) {
        super.init(size: size)
        
        setup()
    }
}

// MARK: Setup
private extension GameScene {
    
    func setup() {
        size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        setupUI()
        generateBlocks()
    }
    
    func setupUI() {
        backgroundSprite = SKSpriteNode(texture: SKTexture(imageNamed: "bg2"))
        backgroundSprite.anchorPoint = CGPoint(x: 0, y: 1.0)
        backgroundSprite.size = self.size
        backgroundSprite.position = CGPoint(x: 0, y: self.size.height)
        scene?.addChild(backgroundSprite)
        
        let textureJoker = SKTexture(imageNamed: "joker")
        jokerSprite = SKSpriteNode(texture: textureJoker)
        jokerSprite.anchorPoint = CGPoint(x: 0.5, y: 1)
        jokerSprite.size = CGSize(width: self.size.width * 1.1,
                                  height: self.size.width * 1.1  * textureJoker.size().height / textureJoker.size().width)
        jokerSprite.position = CGPoint(x: self.size.width / 2, y: self.size.height)
        scene?.addChild(jokerSprite)
    }

    func generateBlocks() {
        let widthBlock = (self.size.width - 40.0) / CGFloat(level.sizeLevel.0)
        (0..<level.sizeLevel.1).reversed().forEach { y in
            (0..<level.sizeLevel.0).reversed().forEach { x in
                guard level.blockMap[y][x] == 1 else { return }
                createBlock(size: CGSize(width: widthBlock, height: widthBlock),
                            position: CGPoint(x: 20.0 + widthBlock * CGFloat(x) + widthBlock/2,
                                              y: 40 + widthBlock * CGFloat(y) + widthBlock/2))
            }
        }
    }
}

// MARK: General
extension GameScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        swipeRightRec.addTarget(self, action: #selector(swipedRight) )
        swipeRightRec.direction = .right
        self.view!.addGestureRecognizer(swipeRightRec)
        
        swipeLeftRec.addTarget(self, action: #selector(swipedLeft) )
        swipeLeftRec.direction = .left
        self.view!.addGestureRecognizer(swipeLeftRec)
        
        
        swipeUpRec.addTarget(self, action: #selector(swipedUp) )
        swipeUpRec.direction = .up
        self.view!.addGestureRecognizer(swipeUpRec)
        
        swipeDownRec.addTarget(self, action: #selector(swipedDown) )
        swipeDownRec.direction = .down
        self.view!.addGestureRecognizer(swipeDownRec)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        if comet == nil {
            guard let block = touchedNode as? Block else { return }
            let size = CGSize(width: block.size.width / 3, height: block.size.width / 3)
            createComet(size: size, position: touchedNode.position)
        }
        
        if let name = touchedNode.name, name == "restart-button" {
            restart()
        }
        
        if let name = touchedNode.name, name == "home-button" {
            presentMenuScene()
        }
    }
}

// MARK: Manage objects
extension GameScene {
    
    func createBlock(size: CGSize, position: CGPoint) {
        let block = Block(size: size)
        scene?.addChild(block)
        block.position = position
        blocks.append(block)
    }
    
    func createComet(size: CGSize, position: CGPoint) {
        comet = Comet(size: size)
        scene?.addChild(comet)
        comet.position = position
    }
    
    func createPauseNode(withTextTexture texture: SKTexture) -> SKNode {
        let node = SKNode()
        node.position = scene!.view!.center
        
        let backgroundNode = SKSpriteNode(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6), size: scene!.size)
        node.addChild(backgroundNode)
        
        let textSpriteNode = SKSpriteNode(texture: texture)
        node.addChild(textSpriteNode)
        
        let restartButtonSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "restart-button"))
        restartButtonSpriteNode.name = "restart-button"
        restartButtonSpriteNode.size = CGSize(width: self.size.width * 50 / 375, height: self.size.width * 50 / 375)
        restartButtonSpriteNode.position = CGPoint(x: 35, y: textSpriteNode.frame.minY - 30)
        node.addChild(restartButtonSpriteNode)
        
        let homeButtonSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "home-button"))
        homeButtonSpriteNode.name = "home-button"
        homeButtonSpriteNode.size = CGSize(width: self.size.width * 50 / 375, height: self.size.width * 50 / 375)
        homeButtonSpriteNode.position = CGPoint(x: -35, y: textSpriteNode.frame.minY - 30)
        node.addChild(homeButtonSpriteNode)
        
        return node
    }
    
    func fadeAndRemove(block: Block) {
        blocks.remove(at: blocks.firstIndex { $0 == block }! )
        let fadeOutAction = SKAction.fadeOut(withDuration: 1.0)
        let remove = SKAction.run({ block.removeFromParent }())
        let sequence = SKAction.sequence([fadeOutAction, remove])
        block.run(sequence)
    }
}

// MARK: Swipes
private extension GameScene {
    
    @objc func swipedRight() {
        comet.startMoving(movementSpeed: CGFloat(level.speed),
                          textureScale: CGFloat(4.0 / CGFloat(level.sizeLevel.0)))
        comet.changeDirection(rotation: .pi / -2, vector: CGVector(dx: 50, dy: 0))
    }
   
    @objc func swipedLeft() {
        comet.startMoving(movementSpeed: CGFloat(level.speed),
                          textureScale: CGFloat(4.0 / CGFloat(level.sizeLevel.0)))
        comet.changeDirection(rotation: .pi / 2, vector: CGVector(dx: -50, dy: 0))
    }
   
    @objc func swipedUp() {
        comet.startMoving(movementSpeed: CGFloat(level.speed),
                          textureScale: CGFloat(4.0 / CGFloat(level.sizeLevel.0)))
        comet.changeDirection(rotation: 0, vector: CGVector(dx: 0, dy: 50))
    }
   
    @objc func swipedDown() {
        comet.startMoving(movementSpeed: CGFloat(level.speed),
                          textureScale: CGFloat(4.0 / CGFloat(level.sizeLevel.0)))
        comet.changeDirection(rotation: .pi, vector: CGVector(dx: 0, dy: -50))
    }
    
}

// MARK: SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
            let nodeB = contact.bodyB.node else { return }
        
        if let block = nodeA as? Block {
            if !blocks.contains(block) { gameOver() }
        } else if let block = nodeB as? Block {
            if !blocks.contains(block) { gameOver() }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
            let nodeB = contact.bodyB.node else { return }
        
        if nodeB.physicsBody!.allContactedBodies().isEmpty && nodeA.physicsBody!.allContactedBodies().isEmpty {
            gameOver()
        } else {
            if let block = nodeA as? Block {
                fadeAndRemove(block: block)
            } else if let block = nodeB as? Block {
                fadeAndRemove(block: block)
            }
            if blocks.count == 1 {
                gameWin()
            }
        }
    }
}

private extension GameScene {
    
    func gameWin() {
        pauseNode = createPauseNode(withTextTexture: SKTexture(imageNamed: "you-win"))
        scene?.addChild(pauseNode)
        comet.speed = 0
    }
    
    func gameOver() {
        pauseNode = createPauseNode(withTextTexture: SKTexture(imageNamed: "try-again"))
        scene?.addChild(pauseNode)
        comet.speed = 0
    }
    
    func restart() {
        removeAllChildren()
        pauseNode = nil
        comet = nil
        blocks = []
        setup()
    }
    
    func presentMenuScene() {
        let nextScene = MenuScene(fileNamed: "MenuScene")
        nextScene?.scaleMode = .resizeFill
        view?.presentScene(nextScene!, transition: SKTransition.fade(withDuration: 0.5))
        removeFromParent()
    }
}
