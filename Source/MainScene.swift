import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate
{
    
    weak var asteroid: CCNode?
    weak var planet: CCNode!
    weak var physicsWorld: CCPhysicsNode!
    
    func didLoadFromCCB()
    {
        userInteractionEnabled = true
        
        physicsWorld.debugDraw = true
        physicsWorld.collisionDelegate = self
        
        //var diffPosition = ccpSub(planet.position,asteroid.position)
        //var direction    = ccpNormalize(diffPosition)
        
        //asteroid.physicsBody.applyImpulse(ccpMult(direction,50))
        //asteroid.physicsBody.applyImpulse(ccp(100,0), atLocalPoint: ccp(0,0))
    }

    override func update(delta: CCTime)
    {
        if let asteroid = asteroid {
            var diffPosition = ccpSub(planet.position, asteroid.position)
            var direction    = ccpNormalize(diffPosition)
            //asteroid.physicsBody.applyForce(ccpMult(direction,500))
        }
    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, asteroid:CCNode!, planet:CCNode!) -> Bool
    {
        println("asteroid collided with planet")
        physicsWorld.removeChild(asteroid)
        //CallBlock(removeAsteroid(asteroid))
        return true
    }
    
    func removeAsteroid(asteroid:CCNode!)
    {
        // load particle effect
        //let explosion = CCBReader.load("SealExplosion") as! CCParticleSystem
        // make the particle effect clean itself up, once it is completed
       // explosion.autoRemoveOnFinish = true;
        // place the particle effect on the seals position
       // explosion.position = seal.position;
        // add the particle effect to the same node the seal is on
        //seal.parent.addChild(explosion)
        asteroid.removeFromParent()
    }
    
    //MARK:- Buttons
    func restart() {
        let gameplayScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(gameplayScene)
    }
    
}
