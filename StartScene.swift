//
//  StartScene.swift
//  SwiftSolaris
//
//  Created by Thea Jensvold-Rumage on 7/31/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class StartScene: CCScene {
    
    var introStarted = false
    weak var scaleNode:CCNode!
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if introStarted == true { return }
        
        introStarted = true
        
        var actionBlock = CCActionCallBlock {
            [unowned self] () -> Void in
            
            let nextScene = CCBReader.loadAsScene("MainScene")
            CCDirector.sharedDirector().replaceScene(nextScene)

        }
        
        scaleNode.runAction(CCActionSequence(array:[actionBlock]))

        
    }
   
}
