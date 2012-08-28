//
//  AWHLevelLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 8/14/12.
//  Copyright 2012 AppsWithHeart. All rights reserved.
//

#import "AWHLevelLayer.h"
#import "AWHGameStateManager.h"
#import "AWHScaleManager.h"
#import "AWHSprite.h"
#import "AWHResourceManager.h"
#import "SimpleAudioEngine.h"


@implementation AWHLevelLayer

-(void)incrementLevel {
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    [gameStateManager gotoNextLevel];
}
/*
-(void)newBackgroundTile {
    AWHSprite *tiledSprite=[[AWHSprite alloc] initWithDict:[AWHResourceManager expandSpriteDict:tiledBackgroundDict]];
    [self addChild:tiledSprite z:0];
}*/

// Interval callback to start the background music
-(void)startBackgrondMusic {
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[backgroundDict objectForKey:@"Music"]];
    [self unschedule:@selector(startBackgrondMusic)];
}

-(void)fire {
    
    
    // First see if we're done
    counter++;
    if (counter <= [[foodDict objectForKey:@"Quantity"] intValue]) {
        NSArray* foodArray = [foodDict objectForKey:@"Sprites"];
        int foodIndex = arc4random() % [foodArray count];  
        NSDictionary* currentSpriteDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         [[foodArray objectAtIndex:foodIndex] objectForKey:@"Name"], @"Name",
                                         [foodDict objectForKey:@"Template"], @"Template",
                                         nil];

        NSLog(@"Food fire %d %@", counter, currentSpriteDict);
        AWHSprite *sprite=[[AWHSprite alloc] initWithDict:[AWHResourceManager expandSpriteDict:currentSpriteDict]];
        [self addChild:sprite z:3];
        [sprite release];
        [currentSpriteDict release];
        [[SimpleAudioEngine sharedEngine] playEffect:[foodDict objectForKey:@"LaunchEffect"]];
    } else {

        [self unschedule:@selector(fire)];
    }
    
    
    /*
    BOOL last = NO;
    if (counter ==29) {
        last = YES;
    }
    Food *food=[[Food alloc] initWithLayer:self lastSprite:last];
    [food release];
    
    counter++;
    [leftScore setString:[NSString stringWithFormat:@"%d", 30-counter]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"Launch.mp3"];
    if (counter>=30) {
        [self unschedule:@selector(fire)];
        //[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    }
    */

}

// on "init" you need to initialize your instance
-(id) init
{
    // Get the state manager and set the level background color
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    
	NSDictionary *levelDict = [gameStateManager getLevelDict];
    backgroundDict = [levelDict objectForKey:@"Background"];
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
        tiledBackgroundDict = [AWHResourceManager expandSpriteDict:[backgroundDict objectForKey:@"Tiled"]];
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
        
        // Start food logic
        foodDict = [levelDict objectForKey:@"Food"];

        
        /*
		// create and initialize a Label
        int level = [gameStateManager theCurrentLevel];
		CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level: %d",level] fontName:@"PressStart2P.ttf" fontSize:46];
        
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , 30 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        CCMenuItemFont *item1 = [CCMenuItemFont itemFromString: @"Next Level" target:self selector:@selector(incrementLevel)];
        item1.color = ccWHITE;
		CCMenu *menu = [CCMenu menuWithItems: item1, nil];
		[self addChild: menu];
        */
       /* 
        // Set the timer to fire new background tiles
        // First, unwind the template to get the speed
        NSDictionary* actions = [tiledBackgroundDict objectForKey:@"Action"];
        NSArray* childActions = [actions objectForKey:@"ChildActions"];
        NSDictionary* moveAction = [childActions objectAtIndex:0];
        int speed = [[moveAction objectForKey:@"Speed"] intValue];
        NSLog(@"Speed: %d Width: %f", speed, [tiledSprite.mySprite boundingBox].size.width);
        [self schedule:@selector(newBackgroundTile) interval:([tiledSprite.mySprite boundingBox].size.width/speed)/1];
        */
        // Background music
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:[backgroundDict objectForKey:@"Music"]];
        [self schedule:@selector(startBackgrondMusic) interval:1.0];
        
        // Food fire
        [[SimpleAudioEngine sharedEngine] preloadEffect:[foodDict objectForKey:@"LaunchEffect"]];
        [self schedule:@selector(fire) interval:[[foodDict objectForKey:@"Interval"] floatValue]];
        
        counter = 0;

	}
	return self;
}

@end
