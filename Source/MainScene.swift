import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate
{
    
    weak var asteroid: CCNode?
    weak var planet: CCNode!
    weak var physicsWorld: CCPhysicsNode!
    weak var deathLeft: CCNodeColor!
    weak var deathTop:CCNodeColor!
    weak var deathRight:CCNodeColor!
    
    func didLoadFromCCB()
    {
        userInteractionEnabled = true
        
       // physicsWorld.debugDraw = true
        physicsWorld.collisionDelegate = self

        self.schedule("createNewAsteroidAndPosition", interval: 2.0)
    }
    
    func createNewAsteroidAndPosition()
    {
        var asteroidX = CCBReader.load("Asteroid") as! Asteroid
        asteroidX.randomPositionLeft()
        physicsWorld.addChild(asteroidX)
        
        var asteroidY = CCBReader.load("Asteroid") as! Asteroid
        asteroidY.randomPositionRight()
        physicsWorld.addChild(asteroidY)
        
        var asteroidZ = CCBReader.load("Asteroid") as! Asteroid
        asteroidY.randomPositionTop()
        physicsWorld.addChild(asteroidZ)
    }

    override func update(delta: CCTime)
    {
        
        for childNode in physicsWorld.children
        {
            if childNode is Asteroid
            {
                let asteroid:Asteroid = childNode as! Asteroid
                asteroid.appliedForceInDirection(planet.position)
            }
            
        }

    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, asteroid:Asteroid!, planet:CCNode!) -> Bool
    {
        println("asteroid collided with planet")
        physicsWorld.removeChild(asteroid)
       
        return true
    }
    
    func ccPhysicsCollisionDeathRight(pair: CCPhysicsCollisionPair!, asteroid:Asteroid!, deathRight:CCNodeColor!) -> Bool
    {
        println("asteroid off screen")
        physicsWorld.removeChild(asteroid)
        
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
    func restart()
    {
        let gameplayScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(gameplayScene)
    }
    
}
