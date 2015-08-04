//
//  IceAsteroid.swift
//  SwiftSolaris
//
//  Created by Thea Jensvold-Rumage on 7/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class IceAsteroid: CCSprite
{
    var isTouched = false
    var touchDirection = CGPointZero
    let spawningAtPercentOfScreen: CGFloat = 0.33
    
    func didLoadFromCCB()
    {
        self.userInteractionEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!)
    {
        println("touchBegan")
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!)
    {
        isTouched = true
        let newLocation: CGPoint = touch.locationInView(CCDirector.sharedDirector().view as! CCGLView)
        let lastLocation: CGPoint = touch.previousLocationInView(CCDirector.sharedDirector().view as! CCGLView)
        
        var touchDiff: CGPoint = ccpSub(newLocation, lastLocation )
        touchDiff.y *= -1
        var touchDirection: CGPoint = touchDiff
        
        println("Diff: \(touchDiff)")
        println("Direction: \(touchDirection)")
        
        self.physicsBody.applyForce(ccpMult(touchDiff, 500))
    }
    
    func appliedForceInDirection(point: CGPoint)
    {
        var diffPosition = ccpSub(point, position)
        var direction    = ccpNormalize(diffPosition)
        
        if isTouched == true {
            direction = touchDirection
        }
        
        physicsBody.applyForce(ccpMult(direction,50))
    }
    
    
    func placeAsteroid()
    {
        let placementSide = random() % 3
        let screenSize = CCDirector.sharedDirector().viewSize()
        
        var x: CGFloat!
        var y: CGFloat!
        
        let percentInPoints = screenSize.height * spawningAtPercentOfScreen
        let randomOffset = random() % Int(percentInPoints)
        switch (placementSide)
        {
            //Left edge
        case 0:
            x = -contentSize.width
            y = screenSize.height - CGFloat(randomOffset)
            //Top edge
        case 1:
            x = CGFloat(random()) % screenSize.height
            y = screenSize.height + contentSize.height
            //Right edge
        case 2:
            x = screenSize.width + contentSize.width
            y = screenSize.height - CGFloat(randomOffset)
        default:
            break
        }
        
        position.x = x
        position.y = y
        
    }
 
}
