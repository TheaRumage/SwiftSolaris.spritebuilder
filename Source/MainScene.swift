import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate
{
    // Main objects
    weak var asteroid: CCNode?
    weak var planet: CCNode!
    weak var blueElement:Gem!
    
    var isTouched = false
    
    //Physics Node
    weak var physicsWorld: CCPhysicsNode!
    
    //Score
    weak var scoreLabel:CCLabelTTF!
    weak var scoreTitle:CCLabelTTF!
    weak var finalScoreLabel: CCLabelTTF!
    weak var highScore:CCLabelTTF!
    weak var highScoreTitle:CCLabelTTF!
    
    // Gem Labels
    weak var blueGemCount:CCLabelTTF!
    weak var greenGemCount:CCLabelTTF!
    
    // Planet shield
    weak var shield:Shield!
    
    var blueGems:Int = 0
    {
        didSet
        {
            blueGemCount.string = String(blueGems)
        }
    }
    var greenGems:Int = 0
    {
        didSet
        {
            greenGemCount.string = String(greenGems)
        }
    }
    
    var score:Int = 0
    {
        didSet
        {
            scoreLabel.string = String(score)
            finalScoreLabel.string = String(score)
        }
    }
    
    // Asteroid spawn time
    var interval:Double = 2.6
    var asteroidCount :Int = 100
    var i: Int = 1
    
    //Lives
    weak var starOne: CCNode!
    weak var starTwo: CCNode!
    weak var starThree:CCNode!
    
    var asteroidCollision: Int = 0
    
    // Death nodes
    weak var death:CCNode!
    
    // Buttons
    weak var restartButton: CCButton!
    weak var pauseButton:CCButton!
    
    func didLoadFromCCB()
    {
        userInteractionEnabled = true
        
        physicsWorld.collisionDelegate = self
        
        self.schedule("createNewAsteroidAndPosition", interval: interval)
        
        //var music
        OALSimpleAudio.sharedInstance().playBg("General Lavine.mp3", loop:true)
    }
    
    //MARK:- Astroid spawing intervals
    func changeInterval()
    {
        
        println(asteroidCount)
        println(interval)
        if asteroidCount == 110 && interval >= 0.2
        {
            asteroidCount -= (10 + (i * 5))
            interval -= 0.2
            println("Interval sped up")
            i++
            self.schedule("createNewAsteroidAndPosition", interval: interval)


        }
    }
    
    
    
    func createNewAsteroidAndPosition()
    {
        var asteroidX = CCBReader.load("Asteroid") as! Asteroid
        asteroidX.placeAsteroid()
        physicsWorld.addChild(asteroidX)
        asteroidCount++
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
        
        changeInterval()
        
        // Blink powerups
        if blueGems == 10
        {
            println("Blinking blue gem")
        }
        if greenGems == 10
        {
            println("Blinking green gem")
        }
        
    }
    // MARK:- Powerups
    func spawnSpaceShips()
    {
        let spaceship = CCBReader.load("Spaceship")
        let screenSize = CCDirector.sharedDirector().viewSize()
    }
    
    func blueGemButton()
    {
        for childNode in physicsWorld.children
        {
            if childNode is Gem            {

                if blueGems >= 10 && shield.visible == false
                {
                    shield.activeShield()
                    blueGems -= 10
                }
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
    
    func destroyGems()
    {
        for childNode in physicsWorld.children
        {
            if childNode is Gem
            {
                let gem:Gem = childNode as! Gem
                
                physicsWorld.space.addPostStepBlock({ () -> Void in
                    gem.removeFromParent()
                    }, key:gem)

            }
        }
    }
    
    //MARK:- Physics
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
                self.shield.removeFromParent()
                planet.removeFromParent()
                self.destroyAsteroids()
                self.destroyGems()
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
            
            
            physicsWorld.space.addPostStepBlock({ () -> Void in
                asteroid.removeFromParent()
                }, key: asteroid)
        }
        
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, asteroid:Asteroid!, shield:CCNode!) -> Bool
    {
        if shield.visible == true
        {
            let zap = CCBReader.load("AsteroidToAsteroidExplosion") as! CCParticleSystem
            zap.autoRemoveOnFinish = true;
            zap.position = asteroid.positionInPoints;
            asteroid.parent.addChild(zap)
            
            physicsWorld.space.addPostStepBlock({ () -> Void in
                asteroid.removeFromParent()
                }, key: zap)
        }
        
        return false
    }

    
    // Asteroid flicked to asteroid death
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, asteroid asteroid1:Asteroid!, asteroid asteroid2:Asteroid!) -> Bool
    {
        if asteroid1.isTouched == true
        {
            score = score + 5
            let bump = CCBReader.load("AsteroidToAsteroidExplosion") as! CCParticleSystem
            bump.autoRemoveOnFinish = true;
            bump.position = asteroid2.positionInPoints;
            asteroid2.parent.addChild(bump)
            
            //Adding gem
            var gem = CCBReader.load("BlueElement") as! Gem
            gem.name = "blue"
            addGem(gem, point: asteroid2.positionInPoints)
             physicsWorld.space.addPostStepBlock({ () -> Void in
                asteroid2.removeFromParent()
                }, key: asteroid1)
            
        }
        
        if asteroid2.isTouched == true
        {
            score = score + 5
            let bump = CCBReader.load("AsteroidToAsteroidExplosion") as! CCParticleSystem
            bump.autoRemoveOnFinish = true;
            bump.position = asteroid1.positionInPoints;
            asteroid1.parent.addChild(bump)
            
            //MARK :- Adding gem
            var gem = CCBReader.load("GreenElement") as! Gem
            gem.name = "green"
            addGem(gem, point: asteroid1.positionInPoints)
            
            physicsWorld.space.addPostStepBlock({ () -> Void in
                asteroid1.removeFromParent()
                }, key: asteroid2)
            
        }
        
        
        return false
    }
    
    //MARK:- Asset Management
    func addGem(gem: Gem, point: CGPoint) {
        gem.position = point
        gem.mainScene = self
        physicsWorld.addChild(gem)
    }
    
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
    
    func pause()
    {
        let gameplayScene = CCBReader.loadAsScene("PauseMenu")
        CCDirector.sharedDirector().pushScene(gameplayScene)
    }
    
}
