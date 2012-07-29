//
//  AWHSprite.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/28/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import "AWHSprite.h"
#import "AWHScaleManager.h"
#import "CCAnimate+SequenceLoader.h"


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
// Revert the sprite to the original actions passed in at init time
-(void) revertOriginalActions {
    [mySprite stopAllActions];
    [mySprite runAction:[self processActions:originalActions]];
}


// Build the data structure of actions to execute on this sprite, recursively if necessary
-(CCAction *)processActions:(NSDictionary *)action {
 
    NSString *actionType = [action objectForKey:@"ActionType"];
    
    // Walk through the action types, first the composite ones
    if ([actionType isEqualToString:@"RepeatForever"]) {
        NSLog(@"Action processing a %@", actionType);
        id childAction = [self processActions:[action objectForKey:@"ChildAction"]];
        return [CCRepeatForever actionWithAction:childAction];
    } 
    else if ([actionType isEqualToString:@"Sequence"]) {
        NSLog(@"Action processing a %@", actionType);
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
        NSLog(@"Action processing a %@", actionType);
        return [CCRotateBy actionWithDuration:[[action objectForKey:@"Duration"] floatValue] angle:[[action objectForKey:@"Angle"] floatValue]];
    }
    else if ([actionType isEqualToString:@"Animate"]) {
        NSLog(@"Action processing a %@", actionType);
        return [CCAnimate actionWithSpriteSequence:[action objectForKey:@"Sequence"]
                                           numFrames:[[action objectForKey:@"NumFrames"] intValue]
                                               delay:[[action objectForKey:@"Delay"] floatValue]
                                restoreOriginalFrame:[[action objectForKey:@"RestoreOriginalFrame"] boolValue]];
    }
    
    // Finally, the custom ones
    else if ([actionType isEqualToString:@"TouchesOn"]) {
        NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(touchesOn)];
    }
    else if ([actionType isEqualToString:@"TouchesOff"]) {
        NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(touchesOff)];
    }
    else if ([actionType isEqualToString:@"RevertOriginalActions"]) {
        NSLog(@"Action processing a %@", actionType);
        return [CCCallFunc actionWithTarget:self selector:@selector(revertOriginalActions)];
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
        self.mySprite=[CCSprite spriteWithSpriteFrameName:[spriteDict objectForKey:@"Name"]];
        
        mySprite.position=[scaleManager scalePointX:[[spriteDict objectForKey:@"PositionX"] floatValue] andY:[[spriteDict objectForKey:@"PositionY"] floatValue]];
        mySprite.scale = [scaleManager scaleImage];
        
        // Set up actions
        originalActions = [spriteDict objectForKey:@"Action"];
        [mySprite runAction:[self processActions:originalActions]];
        
        // Record touch reactions for later
        touchReactions = [spriteDict objectForKey:@"TouchReactions"];
        
        // Set member variables
        [self addChild:mySprite];
        beenTouched = NO;

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
            NSLog(@"Touch processing a %@", touchReactionType);
            [mySprite stopAllActions];
            [mySprite runAction:[self processActions:[reactionDict objectForKey:@"Action"]]];
        } 
    }
    
    //beenTouched = YES;
    return YES;
}

@end
