//
//  AWHGenericLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/2/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import "AWHGenericLayer.h"
#import "AWHSprite.h"
#import "AWHGameStateManager.h"

@implementation AWHGenericLayer

-(void)startOver {
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    [gameStateManager startOver];
}

-(id)initWithDict:(NSDictionary *)levelDict
{
    // Start up the ResourceManager and get/apply the background colors
    
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
        
        // Load the sheets
        NSString *spriteSheet = [levelDict objectForKey:@"SpriteSheet"];
        CCSpriteBatchNode *spritesBNode;
        spritesBNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz", spriteSheet]];
        [self addChild:spritesBNode];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist", spriteSheet]];
        
        // Set up sprites
        for (NSDictionary* spriteDict in [levelDict objectForKey:@"Sprites"] ){
            AWHSprite *sprite=[[AWHSprite alloc] initWithDict:spriteDict];
            [self addChild:sprite];
        }
        
        // Temporary restart menu
        CCMenuItemFont *item1 = [CCMenuItemFont itemFromString: @"Start Over" target:self selector:@selector(startOver)];
        item1.color = ccWHITE;
		CCMenu *menu = [CCMenu menuWithItems: item1, nil];
		[self addChild: menu];        
        
	}
	return self;
}

@end
