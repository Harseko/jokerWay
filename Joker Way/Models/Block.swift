//
//  Block.swift
//  Joker Way
//
//  Created by  Developer on 9/5/20.
//  Copyright © 2020 kharseko. All rights reserved.
//
import SpriteKit

class Block: SKSpriteNode{

    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "block")
        let color = UIColor.clear

        super.init(texture: texture, color: color, size: size)
        
        name = "block"
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.categoryBitMask = ContactCategories.block.rawValue
        physicsBody!.collisionBitMask = ContactCategories.block.rawValue
        physicsBody!.contactTestBitMask = ContactCategories.comet.rawValue
        physicsBody!.isDynamic = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
