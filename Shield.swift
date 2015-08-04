//
//  Shield.swift
//  SwiftSolaris
//
//  Created by Thea Jensvold-Rumage on 8/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Shield: CCSprite
{

    func didLoadFromCCB()
    {
        visible = false
        opacity = 0.0
    }
    
    func activeShield()
    {
        visible = true
        
        var actionFade = CCActionFadeTo(duration: 0.5, opacity: 1.0)
        var actionFadeOut = CCActionFadeTo(duration: 0.5, opacity: 0.0)
        
        var actionDelay = CCActionDelay(duration: 10)
        
        var actionBlock = CCActionCallBlock {
            [unowned self] () -> Void in
            self.visible = false
        }
        self.runAction(CCActionSequence(array: [actionFade, actionDelay,actionBlock,actionFadeOut]))
    }

    
}
