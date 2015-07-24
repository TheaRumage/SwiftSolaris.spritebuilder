import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate
{
    
    weak var asteroid: CCNode?
    weak var planet: CCNode!
    weak var physicsWorld: CCPhysicsNode!
    
    //Score
    weak var scoreLabel:CCLabelTTF!
    
    weak var scoreTitle:CCLabelTTF!
    weak var finalScoreLabel: CCLabelTTF!
    
    weak var highScore:CCLabelTTF!
    weak var highScoreTitle:CCLabelTTF!
    
    var score:Int = 0 {
        didSet {
            scoreLabel.string = String(score)
            finalScoreLabel.string = String(score)
        }
    }


    
    //Lives
    weak var starOne: CCNode!
    weak var starTwo: CCNode!
    weak var starThree:CCNode!
    
    var asteroidCollision: Int = 0
    
    // Death nodes
    weak var death:CCNode!
    
    // Restart button
    weak var restartButton: CCButton!
    
    func didLoadFromCCB()
    {
        userInteractionEnabled = true
        
       // physicsWorld.debugDraw = true
        physicsWorld.collisionDelegate = self

        if planet.parent == physicsWorld
        {
            self.schedule("createNewAsteroidAndPosition", interval: 3.0)
        }
    }
    
    func createNewAsteroidAndPosition()
    {
        var asteroidX = CCBReader.load("Asteroid") as! Asteroid
        asteroidX.placeAsteroid()
        physicsWorld.addChild(asteroidX)

    }

    override func update(delta: CCTime)
    {
            for childNode in physicsWorld.children
            {
                if childNode is Asteroid
                {
                    let asteroid:Asteroid = childNode as! Asteroid
                    asteroid.appliedForceInDirection(planet.positionInPoints)
                }

            }
    }
    
    func destroyAsteroids() {
        for childNode in physicsWorld.children
        {
            if childNode is Asteroid
            {
                let asteroid:Asteroid = childNode as! Asteroid
                
                physicsWorld.space.addPostStepBlock({ () -> Void in
                    asteroid.removeFromParent()
                }, key: asteroid)
            }
            
        }
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, asteroid:Asteroid!, planet:CCNode!) -> Bool
    {
        
        asteroidCollision++
        
        // Exlosion on collision
        let explosion = CCBReader.load("AsteroidExplosions") as! CCParticleSystem
        explosion.autoRemoveOnFinish = true;
        explosion.position = asteroid.position;
        asteroid.parent.addChild(explosion)
        physicsWorld.removeChild(asteroid)
        
        //Shake
        physicsWorld.space.addPostStepBlock({ () -> Void in
            planet.animationManager.runAnimationsForSequenceNamed("Shake")
        }, key: planet)
        
        
        if asteroidCollision == 1
        {
           if starOne != nil
           {
            starOne.removeFromParent()
           }
        }
        
        if asteroidCollision == 2
        {
            if starTwo != nil
            {
               starTwo.removeFromParent()
            }
           
        }

        if asteroidCollision == 3
        {
           self.unschedule("createNewAsteroidAndPosition")
           
            if starThree != nil
            {
                starThree.removeFromParent()
            }
            
           let explosion = CCBReader.load("PlanetExplosion") as! CCParticleSystem
           explosion.autoRemoveOnFinish = true;
           explosion.position = planet.positionInPoints;
           planet.parent.addChild(explosion)
            
            physicsWorld.space.addPostStepBlock({ () -> Void in
                planet.removeFromParent()
                self.destroyAsteroids()
            }, key: "asteroid")
            
            // Final screen menu
            restartButton.visible = true
            scoreLabel.visible = true
            scoreTitle.visible = true
            finalScoreLabel.visible = true
            
            //check highscore
            var defaults = NSUserDefaults.standardUserDefaults()
            let highscore = defaults.objectForKey("highscore") as? Int
            if let highscore = highscore {
                highScore.string = String(stringInterpolationSegment: highscore)
            }
            if score > highscore ?? 0 {
                defaults.setInteger(score, forKey: "highscore")
                defaults.synchronize()
                highScore.string = String(score)
            }
        
            highScore.visible = true
            highScoreTitle.visible = true
            
        }
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, asteroid:Asteroid!, death:CCNode!) -> Bool
    {
        if asteroid.isTouched == true
        {
            score = score + 10
            
            println("Asteroid killed")

            physicsWorld.space.addPostStepBlock({ () -> Void in
                asteroid.removeFromParent()
            }, key: asteroid)
        }
        
        return false
    }
    
    // Asteroid flicked to asteroid death
    //func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, asteroidFlicked:Asteroid!, asteroidIncoming:CCNode!, ) -> Bool
//    {
//        if asteroidFlicked.isTouched == true
//        {
//            score = score + 20
//            
//            println("Asteroid killed")
//            
//            physicsWorld.space.addPostStepBlock({ () -> Void in
//                asteroid.removeFromParent()
//                }, key: asteroid)
//        }
//        
//        return false
//    }
    
    func removeAsteroid(asteroid:CCNode!)
    {
        asteroid.removeFromParent()
    }
    
    //MARK:- Buttons
    func restart()
    {
        let gameplayScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(gameplayScene)
    }
    
}
