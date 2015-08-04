//
//  Gem.swift
//  SwiftSolaris
//
//  Created by Thea Jensvold-Rumage on 7/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Gem: CCSprite
{
    var isTouched = false
    var mainScene:MainScene?
    
    func didLoadFromCCB()
    {
        self.userInteractionEnabled = true
        
        timerForRemoveGem()
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!)
    {
        if isTouched == false {
            // Little gem explosion
            let gemExplosion = CCBReader.load("GemCollection") as! CCParticleSystem
            gemExplosion.autoRemoveOnFinish = true;
            gemExplosion.position = position;
            parent.addChild(gemExplosion)
            
            removeGem()
        }
    }
    
    func removeGem()
    {
        if name == "blue"
        {
            mainScene?.blueGems+=5
        }
        
        if name == "green"
        {
            mainScene?.greenGems+=1
        }
        mainScene = nil
        isTouched = true
        removeFromParent()
    }
    
    func timerForRemoveGem()
    {
        var actionDelay = CCActionDelay(duration: 10)
        
        var actionBlock = CCActionCallBlock {
            [unowned self] () -> Void in
            self.removeFromParent()
        }
        self.runAction(CCActionSequence(array: [actionDelay,actionBlock]))
    }
}
