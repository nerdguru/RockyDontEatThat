//
//  HelloWorldLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/17/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "ScaleManager.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene 
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(242, 220, 219, 255)])) {
		
        ScaleManager *scaleManager = [ScaleManager sharedScaleManager]; 
        
        //CCSprite *bg=[CCSprite spriteWithFile:@"home-bg-1920x1280.png"];
        /*CCSprite *bg=[CCSprite spriteWithFile:@"home-bg-960x640.png"];
        bg.anchorPoint = ccp(0,0);
        bg.position=[scaleManager scalePointX:0 andY:0];
        bg.scale = [scaleManager scaleImage];
        [self addChild: bg];*/
        

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

        
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:[scaleManager scaleFontSize:64]];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        // create and initialize a Label
		CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"TR" fontName:@"Marker Felt" fontSize:[scaleManager scaleFontSize:24]];
		label2.position =  [scaleManager scalePointX:460 andY:300];
		[self addChild: label2];
        
        // create and initialize a Label
		CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"TL" fontName:@"Marker Felt" fontSize:[scaleManager scaleFontSize:24]];
		label3.position =  [scaleManager scalePointX:20 andY:300];
		[self addChild: label3];
        
        // create and initialize a Label
		CCLabelTTF *label4 = [CCLabelTTF labelWithString:@"BL" fontName:@"Marker Felt" fontSize:[scaleManager scaleFontSize:24]];
		label4.position =  [scaleManager scalePointX:20 andY:20];
		[self addChild: label4];
        
        // create and initialize a Label
		CCLabelTTF *label5 = [CCLabelTTF labelWithString:@"BR" fontName:@"Marker Felt" fontSize:[scaleManager scaleFontSize:24]];
		label5.position =  [scaleManager scalePointX:460 andY:20];
		[self addChild: label5];
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
