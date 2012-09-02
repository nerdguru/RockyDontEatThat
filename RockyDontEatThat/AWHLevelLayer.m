//
//  AWHLevelLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 8/14/12.
//  Copyright 2012 AppsWithHeart. All rights reserved.
//

#import "AWHLevelLayer.h"
#import "AWHScaleManager.h"
#import "AWHSprite.h"
#import "AWHResourceManager.h"
#import "SimpleAudioEngine.h"


@implementation AWHLevelLayer

-(void)incrementLevel {
    [gameStateManager gotoNextLevel];
}
-(void)startOver {
    [gameStateManager startOver];
}
/*
-(void)newBackgroundTile {
    AWHSprite *tiledSprite=[[AWHSprite alloc] initWithDict:[AWHResourceManager expandSpriteDict:tiledBackgroundDict]];
    [self addChild:tiledSprite z:0];
}*/

// Interval callback to start the background music
-(void)startBackgrondMusic {
    NSDictionary *levelDict = [gameStateManager getLevelDict];
    NSDictionary *backgroundDict = [levelDict objectForKey:@"Background"];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[backgroundDict objectForKey:@"Music"]];
    [self unschedule:@selector(startBackgrondMusic)];
}

-(void)fire {
    
    // First see if we're done
    gameStateManager.counter--;
    
    NSDictionary *levelDict = [gameStateManager getLevelDict];
    NSDictionary *foodDict = [levelDict objectForKey:@"Food"];
    NSArray* foodArray = [foodDict objectForKey:@"Sprites"];
    int foodIndex = arc4random() % [foodArray count];  
    NSDictionary* currentSpriteDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     [[foodArray objectAtIndex:foodIndex] objectForKey:@"Name"], @"Name",
                                     [foodDict objectForKey:@"Template"], @"Template",
                                     nil];

    NSLog(@"Food fire %d", gameStateManager.counter);
    AWHSprite *sprite=[[AWHSprite alloc] initWithDict:[AWHResourceManager expandSpriteDict:currentSpriteDict]];
    [self addChild:sprite z:3];
    [sprite release];
    [currentSpriteDict release];
    [[SimpleAudioEngine sharedEngine] playEffect:[foodDict objectForKey:@"LaunchEffect"]];
    
    if (gameStateManager.counter == 0) {
        [self unschedule:@selector(fire)];
    }
    [remainingFoods setString:[NSString stringWithFormat:@"%d", gameStateManager.counter]];
}

// on "init" you need to initialize your instance
-(id) init
{
    // Get the state manager and set the level background color
    gameStateManager = [AWHGameStateManager sharedGameStateManager];
    
	NSDictionary *levelDict = [gameStateManager getLevelDict];
    NSDictionary *backgroundDict = [levelDict objectForKey:@"Background"];
	if( (self=[super initWithColor:ccc4([[backgroundDict objectForKey:@"Red"] intValue], 
                                        [[backgroundDict objectForKey:@"Green"] intValue], 
                                        [[backgroundDict objectForKey:@"Blue"] intValue], 
                                        [[backgroundDict objectForKey:@"Opacity"] intValue])])) {
		        
        // Get the ScaleManager
        AWHScaleManager *scaleManager = [AWHScaleManager sharedScaleManager];  
        
        // Set the image format, defaulting to RGBA4444
        NSString *imageFormat = [levelDict objectForKey:@"ImageFormat"];
        if (imageFormat == nil || imageFormat == @"RGBA4444") {
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        } else if (imageFormat == @"RGBA8888") {
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        } 
        
        // Load the sheets
        NSString *spriteSheet = [levelDict objectForKey:@"SpriteSheet"];
        CCSpriteBatchNode *spritesBNode;
        spritesBNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz", spriteSheet]];
        [self addChild:spritesBNode];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist", spriteSheet]];
        
        // Load up background sprites
        NSDictionary *tiledBackgroundDict = [AWHResourceManager expandSpriteDict:[backgroundDict objectForKey:@"Tiled"]];
        AWHSprite *tiledSprite=[[AWHSprite alloc] initWithDict:tiledBackgroundDict];
        [self addChild:tiledSprite z:0];

        for (int loopVar = 0; loopVar < [scaleManager computeNumHorizTiles:[tiledSprite.mySprite boundingBox].size.width]; loopVar++) {
            float x = [scaleManager pointsFromRightBoundary:[tiledSprite.mySprite boundingBox].size.width n:loopVar];
            NSMutableDictionary* tileDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                             [tiledBackgroundDict objectForKey:@"Name"], @"Name",
                                             [tiledBackgroundDict objectForKey:@"PositionY"], @"PositionY",
                                             [NSString stringWithFormat: @"%f", x], @"PositionX",  
                                             [tiledBackgroundDict objectForKey:@"Action"], @"Action",
                                             nil];
            
            AWHSprite *tile=[[AWHSprite alloc] initWithDict:tileDict];
            NSLog(@"Dict: %@", tileDict);
            [self addChild:tile z:0];
            [tileDict release];
            [tile release];
        }
        
        for (NSDictionary* spriteDict in [backgroundDict objectForKey:@"Sprites"] ){
            AWHSprite *sprite=[[AWHSprite alloc] initWithDict:[AWHResourceManager expandSpriteDict:spriteDict]];
            [self addChild:sprite z:1];
            [sprite release];
        }
        
        // Load up protagonist animation
        NSDictionary *protagonist = [levelDict objectForKey:@"Protagonist"];
        AWHSprite *sprite=[[AWHSprite alloc] initWithDict:[protagonist objectForKey:@"MainSprite"]];
        [self addChild:sprite z:2];
        
        [gameStateManager setRemoveX:[[protagonist objectForKey:@"RemoveX"] intValue]];
        [gameStateManager setRemoveY:[[protagonist objectForKey:@"RemoveY"] intValue]];
        gameStateManager.protagonistEffect = [protagonist objectForKey:@"Effect"];
       
        AWHSprite *eatSprite=[[AWHSprite alloc] initWithDict:[protagonist objectForKey:@"EatSprite"]];
        eatSprite.visible = NO;
        [self addChild:eatSprite z:2];
        
        gameStateManager.protagonist = sprite;
        gameStateManager.protagonistEat = eatSprite;
        
        
        // Start food logic
        NSDictionary *foodDict = [levelDict objectForKey:@"Food"];

        
        // Background music
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:[backgroundDict objectForKey:@"Music"]];
        [self schedule:@selector(startBackgrondMusic) interval:1.0];
        
        // Food fire
        [[SimpleAudioEngine sharedEngine] preloadEffect:[foodDict objectForKey:@"LaunchEffect"]];
        [self schedule:@selector(fire) interval:[[foodDict objectForKey:@"Interval"] floatValue]];
        gameStateManager.counter = [[foodDict objectForKey:@"Quantity"] intValue];
        
        // Temporary restart menu
        CCMenuItemFont *item1 = [CCMenuItemFont itemFromString: @"Start Over" target:self selector:@selector(startOver)];
        item1.color = ccWHITE;
		CCMenu *menu = [CCMenu menuWithItems: item1, nil];
        menu.visible = NO;
		[self addChild: menu z:4];
        gameStateManager.restartMenu = menu;
        
        // Finally, load up the HUD
        NSDictionary *hudDict = [levelDict objectForKey:@"HUD"];
        
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
        
        remainingCalls = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", gameStateManager.numCalls] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];
        [remainingCalls setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])]; 
		remainingCalls.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"CallsPositionX"] intValue] + [[hudDict objectForKey:@"CallsSpace"] intValue]  andY:[[hudDict objectForKey:@"CallsPositionY"] intValue]];
		[self addChild: remainingCalls];
        
        

	}
	return self;
}

@end
