import Foundation

class Asteroid: CCSprite {

    func didLoadFromCCB() {
        self.userInteractionEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        println("touchBegan")
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        println("touchMoved")
        let newLocation: CGPoint = touch.locationInView(CCDirector.sharedDirector().view as! CCGLView)
        let lastLocation: CGPoint = touch.previousLocationInView(CCDirector.sharedDirector().view as! CCGLView)
        
        let touchDiff: CGPoint = ccpSub(lastLocation,newLocation)
        
        self.physicsBody.applyImpulse(touchDiff, atLocalPoint: ccp(0,0))
        
        println(touchDiff)
    }


}
