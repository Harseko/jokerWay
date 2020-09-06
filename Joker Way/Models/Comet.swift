//
//  Comet.swift
//  Joker Way
//
//  Created by  Developer on 9/5/20.
//  Copyright © 2020 kharseko. All rights reserved.
//
import SpriteKit

class Comet: SKSpriteNode{

    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "comet")
        let color = UIColor.clear
        
        super.init(texture: texture, color: color, size: size)
        
        name = "comet"
        speed = 0
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
        physicsBody!.categoryBitMask = ContactCategories.comet.rawValue
        physicsBody!.collisionBitMask = ContactCategories.comet.rawValue
        physicsBody!.contactTestBitMask = ContactCategories.comet.rawValue
        physicsBody!.isDynamic = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving(movementSpeed: CGFloat, textureScale scale: CGFloat) {
        if !hasActions() {
            texture = SKTexture(imageNamed: "comet-with-fire")
            size = texture!.size()
            setScale(scale)
            speed = movementSpeed
        }
    }
    
    func changeDirection(rotation: CGFloat, vector: CGVector) {
        zRotation = rotation
        removeAllActions()
        let move = SKAction.move(by: vector, duration: 1.0)
        run(SKAction.repeatForever(move))
    }
}
