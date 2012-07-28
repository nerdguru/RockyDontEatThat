//
//  AWHSprite.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/28/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import "AWHSprite.h"
#import "AWHScaleManager.h"


@implementation AWHSprite 
@synthesize mySprite;

-(CCAction *)processActions:(NSDictionary *)action {
 
    NSString *actionType = [action objectForKey:@"ActionType"];
    
    // Walk through the action types, first the composite ones
    if ([actionType isEqualToString:@"RepeatForever"]) {
        NSLog(@"Processing a %@", actionType);
        id childAction = [self processActions:[action objectForKey:@"ChildAction"]];
        return [CCRepeatForever actionWithAction:childAction];
    } 
    // Now the atomic ones
    else if ([actionType isEqualToString:@"RotateBy"]) {
        NSLog(@"Processing a %@", actionType);
        return [CCRotateBy actionWithDuration:[[action objectForKey:@"Duration"] floatValue] angle:[[action objectForKey:@"Angle"] floatValue]];
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
        [mySprite runAction:[self processActions:[spriteDict objectForKey:@"Action"]]];
        
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

-(BOOL)containsTouch:(UITouch *)touch {
    CGRect r=[mySprite textureRect];
    CGPoint p=[mySprite convertTouchToNodeSpace:touch];
    return CGRectContainsPoint(r, p );
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (![self containsTouch:touch] || beenTouched) return NO;
    
    beenTouched = YES;
    return YES;
}

@end
