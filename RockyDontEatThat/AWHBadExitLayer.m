//
//  AWHBadExitLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/8/12.
//  Copyright 2012 AppsWithHeart. All rights reserved.
//

#import "AWHBadExitLayer.h"
#import "SimpleAudioEngine.h"
#import "AWHSprite.h"


@implementation AWHBadExitLayer

-(void)decrementLives {
    [[SimpleAudioEngine sharedEngine] playEffect:badEffect];
    gameStateManager.numLivesLeft--;
    [remainingCalls setString:[NSString stringWithFormat:@"%d", gameStateManager.numLivesLeft]];
    [self unschedule:@selector(decrementLives)];
}
-(void)playFoodEffect {
    [[SimpleAudioEngine sharedEngine] playEffect:foodEffect];
    [self unschedule:@selector(playFoodEffect)];
}
-(void)gameOver {
    [gameStateManager gameOver];
}

-(id)initWithDict:(NSDictionary *)dict withFileName:(NSString*)fileName
{
	if(self=[super initWithDict:dict]) {
        
        if(gameStateManager.numLivesLeft > 0)
            // Set up sprites
            [self initSpritesArray];
        
        // Set up passed in food
        NSMutableDictionary* eatenFoodDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         fileName, @"Name",
                                         [dict objectForKey:@"FoodPositionY"], @"PositionY",
                                         [dict objectForKey:@"FoodPositionX"], @"PositionX",  
                                         nil];
        AWHSprite *eatSprite=[[AWHSprite alloc] initWithDict:eatenFoodDict];
        [self addChild:eatSprite];
        [eatSprite release];
        [eatenFoodDict release];
        NSArray *chunks = [fileName componentsSeparatedByString: @"."];
        foodEffect = [NSString stringWithFormat:@"%@.mp3",[chunks objectAtIndex:0]];
        NSLog(@"Effect: %@", foodEffect);
        [[SimpleAudioEngine sharedEngine] preloadEffect:foodEffect];
        [self schedule:@selector(playFoodEffect) interval:[[dict objectForKey:@"FoodDelay"] floatValue]];
        
        // Load up the HUD
        NSDictionary *hudDict = [dict objectForKey:@"HUD"];
        AWHSprite *callsSprite=[[AWHSprite alloc] initWithDict:[hudDict objectForKey:@"Sprite"]];
        [self addChild:callsSprite];
        [callsSprite release];
        
        CCLabelTTF *callsLabel = [CCLabelTTF labelWithString:@"x" fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];        
        [callsLabel setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])];
		callsLabel.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"CallsPositionX"] intValue] andY:[[hudDict objectForKey:@"CallsPositionY"] intValue]];
		[self addChild: callsLabel];
        
        remainingCalls = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", gameStateManager.numLivesLeft] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];
        [remainingCalls setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])]; 
		remainingCalls.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"CallsPositionX"] intValue] + [[hudDict objectForKey:@"CallsSpace"] intValue]  andY:[[hudDict objectForKey:@"CallsPositionY"] intValue]];
		[self addChild: remainingCalls];
        
        // Set up Synch Label
        [self initSynchLabel];
        
        if(gameStateManager.numLivesLeft > 0) {
            // Set up the call to decrement the lives
            badEffect = [dict objectForKey:@"BadEffect"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:badEffect];
            [self schedule:@selector(decrementLives) interval:[[dict objectForKey:@"Delay"] floatValue]];
        }
        else 
            [self schedule:@selector(gameOver) interval:[[dict objectForKey:@"Delay"] floatValue]];
        
	}
	return self;
}

-(void)onExit {
    [[SimpleAudioEngine sharedEngine] unloadEffect:foodEffect];

}
@end
