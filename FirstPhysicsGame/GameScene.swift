//
//  GameScene.swift
//  FirstPhysicsGame
//
//  Created by ROY ALAMEH on 9/13/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var ball:SKShapeNode!
    var ballSize = 20.0
    
    var tower:SKShapeNode!
    
    var rubberBand:SKShapeNode!

    var ground:SKShapeNode!
    
    let ballMask:UInt32 = 1
    let groundMask:UInt32 = 2
    let towerMask:UInt32 = 3
    
    var centerX = 200.0
    var centerY = 500.0
    let multiplier = 12.0
    
    var released = true
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        rubberBand = SKShapeNode(circleOfRadius: 10)
        self.addChild(rubberBand)
        
        //don't change x and y because physics body will be in wrong location
        //check why rectangular shape node must be generated in this way
        tower = SKShapeNode(rect: CGRect(x: -20, y: -75, width: 40, height: 150))
        tower.fillColor = UIColor.purple
        tower.position = CGPoint(x: 550, y: 600)
        tower.physicsBody = SKPhysicsBody(rectangleOf: tower.frame.size)
        tower.physicsBody?.affectedByGravity = true
        //tower.physicsBody?.isDynamic = true
        self.addChild(tower)
        
        var joyStick = SKShapeNode(circleOfRadius: 30)
        joyStick.fillColor = UIColor.blue
        joyStick.position = CGPoint(x: centerX, y: centerY)
        joyStick.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        joyStick.physicsBody?.collisionBitMask = 0
        joyStick.physicsBody?.categoryBitMask = 0
        joyStick.physicsBody?.contactTestBitMask = ballMask
        joyStick.physicsBody?.affectedByGravity = false
        self.addChild(joyStick)
    
        ball = SKShapeNode(circleOfRadius: ballSize)
        ball.fillColor = UIColor.red
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballSize)
        ball.physicsBody?.affectedByGravity = true
        ball.position = CGPoint(x: 400, y: 1024)
        
        ball.physicsBody?.categoryBitMask = ballMask
        
        self.addChild(ball)
        
        
        var points = [
            CGPoint(x: 0, y: 400),
            CGPoint(x: 768, y: 400),
        ]
        
        //why is & necessary to convert from array to unsafe mutable pointer?
        ground = SKShapeNode(splinePoints: &points, count: points.count)
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        self.addChild(ground)
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if released == true {
            if (contact.bodyA.categoryBitMask == 1) {
                contact.bodyA.affectedByGravity = true
            }
            else if (contact.bodyB.categoryBitMask == 1) {
                contact.bodyB.affectedByGravity = true
            }
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.position = touch.location(in: self)
            ball.physicsBody?.affectedByGravity = false
            released = false
            
            tower.position = CGPoint(x: 600, y: 550)
            tower.zRotation = 0
            tower.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            tower.physicsBody?.angularVelocity = 0.0
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            ball.position = touch.location(in: self)
            //ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            ball.physicsBody?.velocity = CGVector(dx: (centerX - touch.location(in: self).x) * multiplier, dy: (centerY - touch.location(in: self).y) * multiplier)
            released = true
            //ball.position = CGPoint(x: centerX, y:centerY)
        }
    }
    
    
    
   
    
    override func update(_ currentTime: TimeInterval) {
        rubberBand.removeFromParent()
        if released == false {
            var points = [
                CGPoint(x: centerX, y: centerY),
                CGPoint(x: ball.position.x, y: ball.position.y)
            ]
            rubberBand = SKShapeNode(points: &points, count: points.count)
            self.addChild(rubberBand)
        }
        
    }
}
