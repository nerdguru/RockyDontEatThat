//
//  AWHHomeLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/22/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import "AWHHomeLayer.h"
#import "SimpleAudioEngine.h"
#import "CCAnimate+SequenceLoader.h"
#import "AWHScaleManager.h"
#import "AWHResourceManager.h"
#import "AWHSynchLabel.h"
#import "AWHSprite.h"


@implementation AWHHomeLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AWHHomeLayer *layer = [AWHHomeLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene 
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    // Start up the ResourceManager and get/apply the background colors
    AWHResourceManager *resourceManager = [AWHResourceManager sharedResourceManager];
    NSDictionary *levelDict = [resourceManager levelDictionaryWithIndex:0];
    NSDictionary *backgroundDict = [levelDict objectForKey:@"Background"];
	if( (self=[super initWithColor:ccc4([[backgroundDict objectForKey:@"Red"] intValue], 
                                        [[backgroundDict objectForKey:@"Green"] intValue], 
                                        [[backgroundDict objectForKey:@"Blue"] intValue], 
                                        [[backgroundDict objectForKey:@"Opacity"] intValue])])) {
		
        // Get the ScaleManager
        AWHScaleManager *scaleManager = [AWHScaleManager sharedScaleManager]; 
        
        // Place animated title label
        ccColor3B rockyBrown = ccc3(153,102,51);
        ccColor3B white = ccc3(255,255,255);
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Title.mp3"];
        AWHSynchLabel *synchLabel=[[AWHSynchLabel alloc] initWithLabel:@"Rocky Don't Eat That!" fontName:@"Hobo.ttf" fontSize:[scaleManager scaleFontSize:54] withAnchor:[scaleManager scalePointX:5 andY:250] withBaseColor:rockyBrown withHighlightColor:white withIntervals:[NSArray arrayWithObjects:@"0.15",@"0.70",@"1.05",@"1.42", @"2.30",nil]];
        [self addChild:synchLabel];
        
        
        // Initialize sprite sheet
        
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
        
        float offset=15;
        // Set up Rocky sprite
        CCSprite *rocky = [CCSprite spriteWithSpriteFrameName:@"rocky01.png"];
        rocky.position = [scaleManager scalePointX:offset+85 andY:65];
        rocky.scale = [scaleManager scaleImage];
        NSString *seq = @"rocky%02d.png";
        id rockyAnimate = [CCAnimate actionWithSpriteSequence:seq
                                                    numFrames:2
                                                        delay:0.5
                                         restoreOriginalFrame:NO];
        id rockyRepeat=[CCRepeatForever actionWithAction:rockyAnimate];
        [rocky runAction:rockyRepeat];
        //[spritesBNode addChild:rocky];
        [self addChild:rocky];
        
        // Set up cheese sprites
        for (NSDictionary* spriteDict in [levelDict objectForKey:@"Sprites"] ){
            AWHSprite *sprite=[[AWHSprite alloc] initWithDict:spriteDict];
            [self addChild:sprite];
        }
        
        // Load up the high score labels
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"high-scores" ofType:@"plist"];
        NSDictionary *highScoreDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        NSArray *highScoreArray = [highScoreDict objectForKey:@"scores"];
        float currentY = 230;
        
        CCLabelTTF *hsTitleLabel = [CCLabelTTF labelWithString:@"HIGH SCORES" fontName:@"color basic.ttf" fontSize:[scaleManager scaleFontSize:16] ];
        hsTitleLabel.color = ccc3(255, 0, 0);
		hsTitleLabel.position = [scaleManager scalePointX:350 andY:currentY];
		[self addChild: hsTitleLabel];
        
        
        for (NSDictionary* entryDict in highScoreArray ){
            NSString *name = [entryDict objectForKey:@"name"];
            NSString *score = [entryDict objectForKey:@"score"];
            currentY -= 20;
            CCLabelTTF *currentHSLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@     %@", name, score] fontName:@"color basic.ttf" fontSize:[scaleManager scaleFontSize:16] ];
            currentHSLabel.color = ccc3(255, 0, 0);
            currentHSLabel.position = [scaleManager scalePointX:350 andY:currentY];
            [self addChild: currentHSLabel];
        }
        
        // Play the sound
        [[SimpleAudioEngine sharedEngine] playEffect:@"Title.mp3"];

        
	}
	return self;
}

/*- (void)draw {
    // ...
    
    // draw a simple line
    // The default state is:
    // Line Width: 1
    // color: 255,255,255,255 (white, non-transparent)
    // Anti-Aliased
    glEnable(GL_LINE_SMOOTH);
    ccDrawLine( ccp(307.5-(67.5/2), 230), ccp(307.5+(67.5/2), 230) );
    
    // ...
}*/

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
