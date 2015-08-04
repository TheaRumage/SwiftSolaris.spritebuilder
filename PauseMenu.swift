//
//  PauseMenu.swift
//  SwiftSolaris
//
//  Created by Thea Jensvold-Rumage on 7/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class PauseMenu: CCNode {
 
    func restartMenu()
    {
        let gameplayScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(gameplayScene)
    }
    
    func resumeMenu()
    {
        CCDirector.sharedDirector().popScene()
    }
    
    // MARK:- Share buttons
    func shareButtonTapped()
    {
        var scene = CCDirector.sharedDirector().scenesStack[0] as! CCScene
        var node: AnyObject = scene.children[0]
        var screenshot = screenShotWithStartNode(node as! CCNode)
        
        let sharedText = "Checkout my sweet moves! Do you think you can beat my score?: "
        let itemsToShare = [screenshot, sharedText]
        
        var excludedActivities = [ UIActivityTypeAssignToContact,
            UIActivityTypeAddToReadingList, UIActivityTypePostToTencentWeibo]
        
        var controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        controller.excludedActivityTypes = excludedActivities
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func screenShotWithStartNode(node: CCNode) -> UIImage
    {
        CCDirector.sharedDirector().nextDeltaTimeZero = true
        var viewSize = CCDirector.sharedDirector().viewSize()
        var rtx = CCRenderTexture(width: Int32(viewSize.width), height: Int32(viewSize.height))
        rtx.begin()
        node.visit()
        rtx.end()
        return rtx.getUIImage()
    }
}
