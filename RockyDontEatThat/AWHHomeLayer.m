//
//  AWHHomeLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/22/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import "AWHHomeLayer.h"
#import "SimpleAudioEngine.h"
#import "AWHScaleManager.h"
#import "CCAnimate+SequenceLoader.h"
#import "AWHSynchLabel.h"


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

-(void) changeColor1 {
    label1.color = ccc3(255,255,255);
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(242, 220, 219, 255)])) {
		
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Title.mp3"];
        AWHScaleManager *scaleManager = [AWHScaleManager sharedScaleManager]; 
        AWHSynchLabel *synchLabel=[[AWHSynchLabel alloc] initWithLabel:@"Rocky Don't Eat That!"];
        [self addChild:synchLabel];
        
        //SoundSynchedLabel *mainLabel = [[SoundSynchedLabel alloc] initWithLabel:@"Rocky Don't Eat That!" @"Hobo.ttf" fontSize:[scaleManager scaleFontSize:54]];
        
        //CCSprite *bg=[CCSprite spriteWithFile:@"home-bg-1920x1280.png"];
        /*CCSprite *bg=[CCSprite spriteWithFile:@"home-bg-960x640.png"];
         bg.anchorPoint = ccp(0,0);
         bg.position=[scaleManager scalePointX:0 andY:0];
         bg.scale = [scaleManager scaleImage];
         [self addChild: bg];*/
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        
        
        // Initialize sprite sheet
        CCSpriteBatchNode *spritesBNode;
        spritesBNode = [CCSpriteBatchNode batchNodeWithFile:@"home-sprites.pvr.ccz"];
        [self addChild:spritesBNode];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"home-sprites.plist"];
        
        float offset=15;
        // Set up Rocky sprite
        CCSprite *rocky = [CCSprite spriteWithSpriteFrameName:@"rocky01.png"];
        rocky.position = [scaleManager scalePointX:offset+85 andY:65];
        rocky.scale = [scaleManager scaleImage];
        id rockyAnimate = [CCAnimate actionWithSpriteSequence:@"rocky%02d.png"
                                                    numFrames:2
                                                        delay:0.5
                                         restoreOriginalFrame:NO];
        id rockyRepeat=[CCRepeatForever actionWithAction:rockyAnimate];
        [rocky runAction:rockyRepeat];
        [spritesBNode addChild:rocky];
        
        // Set up cheese sprite
        CCSprite *cheese = [CCSprite spriteWithSpriteFrameName:@"cheese.png"];
        cheese.position = [scaleManager scalePointX:offset+195 andY:65];
        cheese.scale = [scaleManager scaleImage];
        id cheeseRotate=[CCRotateBy actionWithDuration:4.0 angle:360];
        id cheeseRepeat=[CCRepeatForever actionWithAction:cheeseRotate];
        [cheese runAction:cheeseRepeat];
        [spritesBNode addChild:cheese];
        
        // Set up purple grapes sprite
        CCSprite *pgrapes = [CCSprite spriteWithSpriteFrameName:@"pgrapes.png"];
        pgrapes.position = [scaleManager scalePointX:offset+265 andY:65];
        pgrapes.scale = [scaleManager scaleImage];
        id pgrapesRotate=[CCRotateBy actionWithDuration:4.0 angle:360];
        id pgrapesRepeat=[CCRepeatForever actionWithAction:pgrapesRotate];
        [pgrapes runAction:pgrapesRepeat];
        [spritesBNode addChild:pgrapes];
        
        // Set up chocolate sprite
        CCSprite *chocolate = [CCSprite spriteWithSpriteFrameName:@"chocolate.png"];
        chocolate.position = [scaleManager scalePointX:offset+335 andY:65];
        chocolate.scale = [scaleManager scaleImage];
        id chocolateRotate=[CCRotateBy actionWithDuration:4.0 angle:360];
        id chocolateRepeat=[CCRepeatForever actionWithAction:chocolateRotate];
        [chocolate runAction:chocolateRepeat];
        [spritesBNode addChild:chocolate];
        
        // Set up red bone sprite
        CCSprite *rbonetreat = [CCSprite spriteWithSpriteFrameName:@"rbonetreat.png"];
        rbonetreat.position = [scaleManager scalePointX:offset+410 andY:65];
        rbonetreat.scale = [scaleManager scaleImage];
        id rbonetreatRotate=[CCRotateBy actionWithDuration:4.0 angle:360];
        id rbonetreatRepeat=[CCRepeatForever actionWithAction:rbonetreatRotate];
        [rbonetreat runAction:rbonetreatRepeat];
        [spritesBNode addChild:rbonetreat];
        
        
		// create and initialize a Labels
		label1 = [CCLabelTTF labelWithString:@"Rocky" fontName:@"Hobo.ttf" fontSize:[scaleManager scaleFontSize:54]];
        label1.color = ccc3(153,102,51);
		label1.position =  [scaleManager scalePointX:70 andY:280];
        [self addChild: label1];
        id delay = [CCDelayTime actionWithDuration: 2.0];
        id callback=[CCCallFunc actionWithTarget:self selector:@selector(changeColor1)];
        [label1 runAction:[CCSequence actions:delay, callback, nil]];
        
        // create and initialize a Label
		CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Don't" fontName:@"Hobo.ttf" fontSize:[scaleManager scaleFontSize:54]];
        label2.color = ccc3(153,102,51);
		label2.position =  [scaleManager scalePointX:210 andY:280];
		[self addChild: label2];
        
        // create and initialize a Label
		CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"Eat" fontName:@"Hobo.ttf" fontSize:[scaleManager scaleFontSize:54]];
        label3.color = ccc3(153,102,51);
		label3.position =  [scaleManager scalePointX:320 andY:280];
		[self addChild: label3];
        
        // create and initialize a Label
		CCLabelTTF *label4 = [CCLabelTTF labelWithString:@"That!" fontName:@"Hobo.ttf" fontSize:[scaleManager scaleFontSize:54]];
        label4.color = ccc3(153,102,51);
		label4.position =  [scaleManager scalePointX:420 andY:280];
		[self addChild: label4];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"Title.mp3"];
	}
	return self;
}

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
