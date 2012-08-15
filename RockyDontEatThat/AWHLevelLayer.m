//
//  AWHLevelLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 8/14/12.
//  Copyright 2012 AppsWithHeart. All rights reserved.
//

#import "AWHLevelLayer.h"
#import "AWHGameStateManager.h"


@implementation AWHLevelLayer

-(void)incrementLevel {
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    [gameStateManager gotoNextLevel];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
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
	}
	return self;
}

@end
