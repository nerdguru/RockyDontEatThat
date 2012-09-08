//
//  AWHMainLevelLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/6/12.
//  Copyright 2012 AppsWithHeart. All rights reserved.
//

#import "AWHMainLevelLayer.h"
#import "AWHResourceManager.h"
#import "SimpleAudioEngine.h"


@implementation AWHMainLevelLayer
@synthesize removeX;
@synthesize removeY;
@synthesize protagonistNormal;
@synthesize protagonistEat;
@synthesize protagonistEffect;
@synthesize scoreEffect;

// Interval for foods being fired
-(void)fire {
    
    // First see if we're done
    gameStateManager.spritesCounter--;
    
    NSDictionary *levelDict = [gameStateManager getLevelDict];
    NSDictionary *foodDict = [levelDict objectForKey:@"Food"];
    NSArray* foodArray = [foodDict objectForKey:@"Sprites"];
    int foodIndex = arc4random() % [foodArray count];  
    NSDictionary* currentSpriteDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [[foodArray objectAtIndex:foodIndex] objectForKey:@"Name"], @"Name",
                                       [[foodArray objectAtIndex:foodIndex] objectForKey:@"Value"], @"Value",
                                       [foodDict objectForKey:@"Template"], @"Template",
                                       nil];
    
    AWHSprite *sprite=[[AWHSprite alloc] initWithDict:[AWHResourceManager expandSpriteDict:currentSpriteDict]];
    [self addChild:sprite z:3];
    [sprite release];
    [currentSpriteDict release];
    [[SimpleAudioEngine sharedEngine] playEffect:[foodDict objectForKey:@"LaunchEffect"]];
    
    if (gameStateManager.spritesCounter == 0) {
        [self unschedule:@selector(fire)];
    }
    [remainingFoods setString:[NSString stringWithFormat:@"%d", gameStateManager.spritesCounter]];
}

-(id)initWithDict:(NSDictionary *)dict
{
	if(self=[super initWithDict:dict]) {
        
        // Load up protagonist animation
        NSDictionary *protagonistDict = [dict objectForKey:@"Protagonist"];
        AWHSprite *sprite=[[AWHSprite alloc] initWithDict:[protagonistDict objectForKey:@"MainSprite"]];
        [self addChild:sprite z:2];
        
        removeX = [[protagonistDict objectForKey:@"RemoveX"] intValue];
        removeY = [[protagonistDict objectForKey:@"RemoveY"] intValue];
        protagonistEffect = [protagonistDict objectForKey:@"Effect"];
        
        AWHSprite *eatSprite=[[AWHSprite alloc] initWithDict:[protagonistDict objectForKey:@"EatSprite"]];
        eatSprite.visible = NO;
        [self addChild:eatSprite z:2];
        [eatSprite release];
        
        protagonistNormal = sprite;
        protagonistEat = eatSprite;
        
        // Start food logic
        NSDictionary *foodDict = [dict objectForKey:@"Food"];
        
        // Food fire
        [[SimpleAudioEngine sharedEngine] preloadEffect:[foodDict objectForKey:@"LaunchEffect"]];
        [self schedule:@selector(fire) interval:[[foodDict objectForKey:@"Interval"] floatValue]];
        gameStateManager.spritesCounter = [[foodDict objectForKey:@"Quantity"] intValue];
        gameStateManager.activeSprites = gameStateManager.spritesCounter;
        
        // Preload scoring effect
        scoreEffect = [foodDict objectForKey:@"ScoreEffect"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:scoreEffect];

        
        // Finally, load up the HUD
        NSDictionary *hudDict = [dict objectForKey:@"HUD"];
        
        // Level Score Labels
		CCLabelTTF *eatenLabel = [CCLabelTTF labelWithString:[hudDict objectForKey:@"ScoreLabel"] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];
        [eatenLabel setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])];
		eatenLabel.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"ScorePositionX"] intValue] andY:[[hudDict objectForKey:@"ScorePositionY"] intValue]];
		[self addChild: eatenLabel];
        
        eatenScore = [CCLabelTTF labelWithString:@"0" fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];
        [eatenScore setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])]; 
		eatenScore.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"ScorePositionX"] intValue]+ [[hudDict objectForKey:@"ScoreSpace"] intValue] andY:[[hudDict objectForKey:@"ScorePositionY"] intValue]];
		[self addChild: eatenScore];
        
        // Remaining Labels
        CCLabelTTF *remainingLabel = [CCLabelTTF labelWithString:[hudDict objectForKey:@"RemainingLabel"] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];        
        [remainingLabel setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])];
		remainingLabel.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"RemainingPositionX"] intValue] andY:[[hudDict objectForKey:@"RemainingPositionY"] intValue]];
		[self addChild: remainingLabel];
        
        remainingFoods = [CCLabelTTF labelWithString:[foodDict objectForKey:@"Quantity"] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];
        [remainingFoods setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])]; 
		remainingFoods.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"RemainingPositionX"] intValue]+ [[hudDict objectForKey:@"RemainingSpace"] intValue] andY:[[hudDict objectForKey:@"RemainingPositionY"] intValue]];
		[self addChild: remainingFoods];
        
        // Num calls left
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
        
	}
	return self;
}

// As actions happen, update the score
-(void)updateScore:(int)points {
    [eatenScore setString:[NSString stringWithFormat:@"%d", points]];
}

@end
