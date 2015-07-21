import Foundation

class Asteroid: CCSprite {
    
    var isTouched = false

    func didLoadFromCCB() {
        self.userInteractionEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!)
    {
        println("touchBegan")
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!)
    {
        println("touchMoved")
        let newLocation: CGPoint = touch.locationInView(CCDirector.sharedDirector().view as! CCGLView)
        let lastLocation: CGPoint = touch.previousLocationInView(CCDirector.sharedDirector().view as! CCGLView)
        
        let touchDiff: CGPoint = ccpSub(lastLocation,newLocation)
        
        self.physicsBody.applyImpulse(touchDiff, atLocalPoint: ccp(0,0))
        
        println(touchDiff)
    }
    
    func appliedForceInDirection(point: CGPoint)
    {
            var diffPosition = ccpSub(point, position)
            var direction    = ccpNormalize(diffPosition)
            physicsBody.applyForce(ccpMult(direction,100))
        
    }
        
    func randomPositionLeft()
    {
        var rangeX = Int(CGFloat(arc4random_uniform(70)) + contentSizeInPoints.width/2)
        var rangeY = Int(arc4random_uniform(150))
        position = CGPoint(x: -rangeX, y: 350 + rangeY)
    }
    
    func randomPositionTop()
    {
        var rangeX = Int(CGFloat(arc4random_uniform(70)) + contentSizeInPoints.width/2)
        var rangeY = Int(arc4random_uniform(150))
        position = CGPoint(x: -rangeX, y: 868 + rangeY)
    }
    
    func randomPositionRight()
    {
        var rangeX = Int(CGFloat(arc4random_uniform(70)) + contentSizeInPoints.width/2)
        var rangeY = Int(arc4random_uniform(150))
        position = CGPoint(x: rangeX, y: 350 + rangeY)
    }


}
