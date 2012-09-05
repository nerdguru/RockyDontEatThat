//
//  AWHBaseLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/5/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//
//  Base logic for all other layers to derive from

#import "AWHBaseLayer.h"
#import "AWHResourceManager.h"
#import "SimpleAudioEngine.h"


@implementation AWHBaseLayer

-(id)init
{
    // Get the ScaleManager
    scaleManager = [AWHScaleManager sharedScaleManager];
    
    // Get the state manager and set the level background color
    gameStateManager = [AWHGameStateManager sharedGameStateManager];
    NSDictionary *levelDict = [gameStateManager getLevelDict];
    
    // Background, required
    NSDictionary *backgroundDict = [levelDict objectForKey:@"Background"];
	if( (self=[super initWithColor:ccc4([[backgroundDict objectForKey:@"Red"] intValue], 
                                        [[backgroundDict objectForKey:@"Green"] intValue], 
                                        [[backgroundDict objectForKey:@"Blue"] intValue], 
                                        [[backgroundDict objectForKey:@"Opacity"] intValue])])) {
        
        // Set the image format, defaulting to RGBA4444
        NSString *imageFormat = [levelDict objectForKey:@"ImageFormat"];
        if (imageFormat == nil || imageFormat == @"RGBA4444") {
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        } else if (imageFormat == @"RGBA8888") {
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        } 
        
        // Load the sheets, SpriteSheets, required
        NSString *spriteSheet = [levelDict objectForKey:@"SpriteSheet"];
        CCSpriteBatchNode *spritesBNode;
        spritesBNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz", spriteSheet]];
        [self addChild:spritesBNode];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist", spriteSheet]];
        
        // Load up background sprites
        NSDictionary *tiledBackgroundDict = [AWHResourceManager expandSpriteDict:[backgroundDict objectForKey:@"Tiled"]];
        if(tiledBackgroundDict != nil) {
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
                //NSLog(@"Dict: %@", tileDict);
                [self addChild:tile z:0];
                [tileDict release];
                [tile release];
            }
        }
        
        // Sprites, optional
        for (NSDictionary* spriteDict in [backgroundDict objectForKey:@"Sprites"] ){
            AWHSprite *sprite=[[AWHSprite alloc] initWithDict:[AWHResourceManager expandSpriteDict:spriteDict]];
            [self addChild:sprite z:1];
            [sprite release];
        }
        
	}
	return self;
}

@end
