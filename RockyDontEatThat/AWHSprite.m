//
//  AWHSprite.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/28/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import "AWHSprite.h"

#import "CCAnimate+SequenceLoader.h"
#import "AWHScaleManager.h"
#import "AWHResourceManager.h"
#import "AWHGameStateManager.h"
#import "SimpleAudioEngine.h"


@implementation AWHSprite 
@synthesize mySprite;

// Custom actions

// Turn the touches on
-(void) touchesOn {
    beenTouched = NO;
}
// Turn the touches off
-(void) touchesOff {
    beenTouched = YES;
}
// Flip to the next level
-(void) nextLevel {
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    [gameStateManager gotoNextInstructions];
}
// Start the level
-(void) startLevel {
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    [gameStateManager gotoNextLevel];
}
// Start the whole thing over
-(void)startOver {
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    [gameStateManager startOver];
}
// Revert the sprite to the original actions passed in at init time
-(void) revertOriginalActions {
    [mySprite stopAllActions];
    [mySprite runAction:[self processActions:originalActions]];
}
// Test method that loads the high score plist from fileand saves it to user defaults
-(void) loadSaveHighScores {
    AWHResourceManager *resourceManager = [AWHResourceManager sharedResourceManager];
    [resourceManager loadHighScoresPlist];
    [resourceManager saveHighScores];
}
// Get rid of the sprite
-(void) removeMe {
    [self removeFromParentAndCleanup:YES];
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    if(beenEaten){
        if (value < 0) {
        // Ate a bad thing, stop the level
            [gameStateManager badExit:fileName];
        } else {
        // Ate a good thing, award points
            [gameStateManager awardPoints:value];
            [gameStateManager detectGoodExit];
        }
    } else {
        if (value < 0) {
        // Bad thing went off, award points
            [gameStateManager awardPoints:value*-1];
            [gameStateManager detectGoodExit];
        } else {
        // Good thing went off, do nothing
            [gameStateManager detectGoodExit];
        }
    }
    
}
-(void) makeVisible {
    mySprite.visible = YES;
}
-(void) eatEffect {
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    [gameStateManager playProtagonistEffect];
}

-(void) eatStart {
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    [gameStateManager showEatProtagonist];
}

-(void) eatEnd {
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    [gameStateManager showNormalProtagonist];
    beenEaten = YES;
}

// Build the data structure of actions to execute on this sprite, recursively if necessary
-(CCAction *)processActions:(NSDictionary *)action {
 
    NSString *actionType = [action objectForKey:@"ActionType"];
    
    // Walk through the action types, first the composite ones
    if ([actionType isEqualToString:@"RepeatForever"]) {
        //NSLog(@"Action processing a %@", actionType);
        id childAction = [self processActions:[action objectForKey:@"ChildAction"]];
        return [CCRepeatForever actionWithAction:childAction];
    } else if ([actionType isEqualToString:@"Repeat"]) {
        // Remember that you can't embed a RepateForever inside a Sequence,hence the need for Repeat
        //NSLog(@"Action processing a %@", actionType);
        id childAction = [self processActions:[action objectForKey:@"ChildAction"]];
        return [CCRepeat actionWithAction:childAction times:[[action objectForKey:@"Times"] intValue]];
    } else if ([actionType isEqualToString:@"Parallel"]) {
        //NSLog(@"Action processing a %@", actionType);
        NSArray *childArray = [action objectForKey:@"ChildActions"];
        NSMutableArray *actionsArray = [[NSMutableArray alloc] initWithCapacity:(childArray.count)];
        for (NSDictionary* childDict in childArray ){
            CCAction *currentAction = [self processActions:childDict];
            [actionsArray addObject:currentAction];
        }
        return [CCSpawn actionsWithArray:actionsArray];
    } else if ([actionType isEqualToString:@"Sequence"]) {
        //NSLog(@"Action processing a %@", actionType);
        NSArray *childArray = [action objectForKey:@"ChildActions"];
        NSMutableArray *actionsArray = [[NSMutableArray alloc] initWithCapacity:(childArray.count)];
        for (NSDictionary* childDict in childArray ){
            CCAction *currentAction = [self processActions:childDict];
            [actionsArray addObject:currentAction];
        }
        return [CCSequence actionsWithArray:actionsArray];
    }
    
    // Now the atomic ones
    else if ([actionType isEqualToString:@"RotateBy"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCRotateBy actionWithDuration:[[action objectForKey:@"Duration"] floatValue] angle:[[action objectForKey:@"Angle"] floatValue]];
    }
    else if ([actionType isEqualToString:@"Delay"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCDelayTime actionWithDuration:[[action objectForKey:@"Duration"] floatValue]];
    }
    else if ([actionType isEqualToString:@"Rotate"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCRotateBy actionWithDuration:[[action objectForKey:@"Duration"] floatValue] angle:[[action objectForKey:@"Angle"] floatValue]];
    }
    else if ([actionType isEqualToString:@"ScaleBy"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCScaleBy actionWithDuration:[[action objectForKey:@"Duration"] floatValue]  scale:[[action objectForKey:@"Scale"] floatValue]];
    }
    else if ([actionType isEqualToString:@"FadeOut"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCFadeOut actionWithDuration:[[action objectForKey:@"Duration"] floatValue]];
    }
    
    else if ([actionType isEqualToString:@"FadeIn"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCFadeIn actionWithDuration:[[action objectForKey:@"Duration"] floatValue]];
    }
    else if ([actionType isEqualToString:@"MoveTo"]) {
        //NSLog(@"Action processing a %@", actionType);
        AWHScaleManager *scaleManager = [AWHScaleManager sharedScaleManager]; 
        float positionX = [scaleManager convertDimension:[action objectForKey:@"PositionX"] ofSprite:self.mySprite];
        float positionY = [scaleManager convertDimension:[action objectForKey:@"PositionY"] ofSprite:self.mySprite];
        
        // The speed might be relative to a future position of the sprite, not the initial one
        float startX = self.mySprite.position.x;
        float startY = self.mySprite.position.y;
        NSString* futureXstr = [action objectForKey:@"FutureX"];
        if(futureXstr != nil) {
            startX = [scaleManager convertDimension:futureXstr ofSprite:self.mySprite];
            NSString* futureYstr = [action objectForKey:@"FutureY"];
            startY = [scaleManager convertDimension:futureYstr ofSprite:self.mySprite];
            CGPoint start = [scaleManager  scalePointX:startX andY:startY];
            startX= start.x;
            startY= start.y;
        }
    
        // Compute the duration and create the sprite
        float duration;
        if ([action objectForKey:@"Duration"]) {
            duration = [[action objectForKey:@"Duration"] floatValue ];
        } else {
            duration = [scaleManager computeDurationFromSpeed:[action objectForKey:@"Speed"] fromX:startX fromY:startY toX:positionX toY:positionY];
        }
        
        //NSLog(@"X: %f Y:%f Duration: %f", positionX,positionY, duration);
        return [CCMoveTo actionWithDuration:duration position:[scaleManager  scalePointX:positionX andY:positionY]];
    }
    else if ([actionType isEqualToString:@"Animate"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCAnimate actionWithSpriteSequence:[action objectForKey:@"Sequence"]
                                           numFrames:[[action objectForKey:@"NumFrames"] intValue]
                                               delay:[[action objectForKey:@"Delay"] floatValue]
                                restoreOriginalFrame:[[action objectForKey:@"RestoreOriginalFrame"] boolValue]];
    }
    
    // Finally, the custom ones
    else if ([actionType isEqualToString:@"TouchesOn"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(touchesOn)];
    }
    else if ([actionType isEqualToString:@"TouchesOff"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(touchesOff)];
    }
    else if ([actionType isEqualToString:@"NextLevel"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(nextLevel)];
    } else if ([actionType isEqualToString:@"StartLevel"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(startLevel)];
    }
    else if ([actionType isEqualToString:@"StartOver"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(startOver)];
    }
    else if ([actionType isEqualToString:@"MakeVisible"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(makeVisible)];
    }
    else if ([actionType isEqualToString:@"RevertOriginalActions"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(revertOriginalActions)];
    }
    else if ([actionType isEqualToString:@"LoadSaveHighScores"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(loadSaveHighScores)];
    }
    else if ([actionType isEqualToString:@"RemoveMe"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(removeMe)];
    } else if ([actionType isEqualToString:@"EatEffect"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(eatEffect)];
    } else if ([actionType isEqualToString:@"EatStart"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(eatStart)];
    } else if ([actionType isEqualToString:@"EatEnd"]) {
        //NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(eatEnd)];
    }
    
    // Return a nil if nothing matched
    return nil;
}

-(id)initWithDict:(NSDictionary *)spriteDict
{
    self = [super init];
    if (self) {
        
        // Initialize the sprite with data from the dict and with the help of the scaleManager
        AWHScaleManager *scaleManager = [AWHScaleManager sharedScaleManager]; 
        fileName = [spriteDict objectForKey:@"Name"];
        self.mySprite=[CCSprite spriteWithSpriteFrameName:fileName];
        mySprite.scale = [scaleManager scaleImage];
        mySprite.position=[scaleManager scalePointX:[scaleManager convertDimension:[spriteDict objectForKey:@"PositionX"] ofSprite:self.mySprite] andY:[scaleManager convertDimension:[spriteDict objectForKey:@"PositionY"] ofSprite:self.mySprite]];
        //NSLog(@"Position: x %f y %f", mySprite.position.x,mySprite.position.y);
        //NSLog(@"Dimensions: w %f h %f", [mySprite boundingBox].size.width,[mySprite boundingBox].size.height);
        
        NSString* startHidden = [spriteDict objectForKey:@"StartHidden"];
        if([startHidden isEqualToString:@"YES"])
            mySprite.visible = NO;
        
        
        // Set up actions
        originalActions = [spriteDict objectForKey:@"Action"];
        if(originalActions!= nil)
            [mySprite runAction:[self processActions:originalActions]];
        
        // Record touch reactions for later
        touchReactions = [spriteDict objectForKey:@"TouchReactions"];
        
        // Set the value, if any
        NSString* spriteValue = [spriteDict objectForKey:@"Value"];
        if(spriteValue != nil){
            value = [spriteValue intValue];
        } else {
            value = 0;
        }
        
        // Set member variables
        [self addChild:mySprite];
        beenTouched = NO;
        beenEaten = NO;

    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

//onEnter
- (void)onEnter
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

//onExit
- (void)onExit
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

-(CGRect) mySpriteRect
{
    return CGRectMake(mySprite.position.x - mySprite.contentSize.width*mySprite.anchorPoint.x,
                      mySprite.position.y - mySprite.contentSize.height*mySprite.anchorPoint.y,
                      mySprite.contentSize.width, mySprite.contentSize.height);   
}

// Rewrote this one from the Bob Ueland example since his didn't work with sprite sheets
// http://stackoverflow.com/questions/7070486/make-a-rectangle-around-a-sprite-in-cocos2d
// http://www.cocos2d-iphone.org/forum/topic/12115
-(BOOL)containsTouch:(UITouch *)touch {
    CGRect r=[self mySpriteRect];
    CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    return CGRectContainsPoint(r, location );
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (![self containsTouch:touch] || beenTouched) return NO;
    
    for (NSDictionary* reactionDict in touchReactions ){
        NSString * touchReactionType = [reactionDict objectForKey:@"TouchReactionType"];
        if ([touchReactionType isEqualToString:@"Actions"]) {
            //NSLog(@"Touch processing a %@", touchReactionType);
            [mySprite stopAllActions];
            [mySprite runAction:[self processActions:[reactionDict objectForKey:@"Action"]]];
        } 
    }
    
    //beenTouched = YES;
    return YES;
}

@end
