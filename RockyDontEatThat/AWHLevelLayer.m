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


@implementation AWHLevelLayer

-(void)incrementLevel {
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    [gameStateManager gotoNextLevel];
}

// on "init" you need to initialize your instance
-(id) init
{
    // Get the state manager and set the level background color
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    
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
        for (NSDictionary* spriteDict in [backgroundDict objectForKey:@"Sprites"] ){
            AWHSprite *sprite=[[AWHSprite alloc] initWithDict:spriteDict];
            [self addChild:sprite];
        }
        
        // Load up protagonist animation
        NSDictionary *protagonist = [levelDict objectForKey:@"Protagonist"];
        AWHSprite *sprite=[[AWHSprite alloc] initWithDict:[protagonist objectForKey:@"MainSprite"]];
        [self addChild:sprite];
        
        
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
	}
	return self;
}

@end
