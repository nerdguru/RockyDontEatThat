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
#import "AWHSynchLabel.h"
#import "AWHHighScoreLabels.h"
#import "AWHSprite.h"


@implementation AWHBaseLayer

// Interval callback to start the background music
-(void)startBackgrondMusic {
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:backgroundMusic];
    [self unschedule:@selector(startBackgrondMusic)];
}

-(id)initWithDict:(NSDictionary *)layerDict;
{
    // Get the ScaleManager
    scaleManager = [AWHScaleManager sharedScaleManager];
    
    // Get the state manager and set the level background color
    gameStateManager = [AWHGameStateManager sharedGameStateManager];
    myDict = layerDict;
    
    // Background, required
    NSDictionary *backgroundDict = [myDict objectForKey:@"Background"];
	if( (self=[super initWithColor:ccc4([[backgroundDict objectForKey:@"Red"] intValue], 
                                        [[backgroundDict objectForKey:@"Green"] intValue], 
                                        [[backgroundDict objectForKey:@"Blue"] intValue], 
                                        [[backgroundDict objectForKey:@"Opacity"] intValue])])) {
        
        // Set the image format, defaulting to RGBA4444
        NSString *imageFormat = [myDict objectForKey:@"ImageFormat"];
        if (imageFormat == nil || imageFormat == @"RGBA4444") {
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        } else if (imageFormat == @"RGBA8888") {
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        } 
        
        // Load the sheets, SpriteSheets, required
        NSString *spriteSheet = [myDict objectForKey:@"SpriteSheet"];
        CCSpriteBatchNode *spritesBNode;
        spritesBNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz", spriteSheet]];
        [self addChild:spritesBNode];    
        [CCSpriteFrameCache purgeSharedSpriteFrameCache]; // Remove what was there before
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
        
        // Background music, optional
        backgroundMusic = [backgroundDict objectForKey:@"Music"];
        if(backgroundMusic != nil) {
            [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:backgroundMusic];
            [self schedule:@selector(startBackgrondMusic) interval:1.0];
        }
        
	}
	return self;
}

-(void)initSpritesArray {
    // Set up sprites
    for (NSDictionary* spriteDict in [myDict objectForKey:@"Sprites"] ){
        AWHSprite *sprite=[[AWHSprite alloc] initWithDict:spriteDict];
        [self addChild:sprite];
    }
}

-(void)initSynchLabel {
    // First, get the right dict and preload the sound
    NSDictionary *synchLabelDict = [myDict objectForKey:@"SynchLabel"];
    NSString* audio = [synchLabelDict objectForKey:@"Audio"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:audio];
    
    ccColor3B baseColor = ccc3([[synchLabelDict objectForKey:@"BaseColorR"] intValue],
                               [[synchLabelDict objectForKey:@"BaseColorG"] intValue],
                               [[synchLabelDict objectForKey:@"BaseColorB"] intValue]);
    ccColor3B highlightColor = ccc3([[synchLabelDict objectForKey:@"HighlightColorR"] intValue],
                               [[synchLabelDict objectForKey:@"HighlightColorG"] intValue],
                               [[synchLabelDict objectForKey:@"HighlightColorB"] intValue]);

    AWHSynchLabel *synchLabel=[[AWHSynchLabel alloc] initWithLabel:[synchLabelDict objectForKey:@"Label"] 
                                                          fontName:[synchLabelDict objectForKey:@"Font"] 
                                                          fontSize:[scaleManager scaleFontSize:[[synchLabelDict objectForKey:@"FontSize"] intValue]] 
                                                        withAnchor:[scaleManager scalePointX:[[synchLabelDict objectForKey:@"PositionX"] intValue] andY:[[synchLabelDict objectForKey:@"PositionY"] intValue]] 
                                                     withBaseColor:baseColor 
                                                withHighlightColor:highlightColor 
                                                     withIntervals:[synchLabelDict objectForKey:@"Intervals"]];
    [self addChild:synchLabel];
    
    // Play the sound
    [[SimpleAudioEngine sharedEngine] playEffect:audio];
}
-(void)initHighScores {
    // Load up the high score labels
    AWHHighScoreLabels *highScoreLabels = [[AWHHighScoreLabels alloc] initWithArray:[gameStateManager getHighScores]];
    [self addChild:highScoreLabels];

}
-(void)initLabelsArray {
    // Set up sprites
    for (NSDictionary* labelDict in [myDict objectForKey:@"Labels"] ){
        CCLabelTTF *currentLabel = [CCLabelTTF labelWithString:[labelDict objectForKey:@"Text"] 
                                                      fontName:[labelDict objectForKey:@"Font"] 
                                                      fontSize:[scaleManager scaleFontSize:[[labelDict objectForKey:@"FontSize"] intValue]]];
        currentLabel.color = ccc3([[labelDict objectForKey:@"ColorR"] intValue],
                                   [[labelDict objectForKey:@"ColorG"] intValue],
                                   [[labelDict objectForKey:@"ColorB"] intValue]);
        currentLabel.anchorPoint=ccp(0,0);
        currentLabel.position = [scaleManager scalePointX:[[labelDict objectForKey:@"PositionX"] intValue] andY:[[labelDict objectForKey:@"PositionY"] intValue]] ;
        [self addChild:currentLabel];
    }
}
@end
