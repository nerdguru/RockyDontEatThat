//
//  AWHInstructionsLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AWHInstructionsLayer.h"


@implementation AWHInstructionsLayer

-(void)startLevel {
    [gameStateManager gotoNextLevel];
}

-(id)initWithDict:(NSDictionary *)dict
{
	if(self=[super initWithDict:dict]) {
        
        // Set up sprites
        [self initSpritesArray];
        
        // Start menu
        CCMenuItemFont *item1 = [CCMenuItemFont itemFromString: @"StartLevel" target:self selector:@selector(startLevel)];
        item1.color = ccWHITE;
        item1.fontSize = [scaleManager scaleFontSize:26];
        item1.fontName = @"Hobo.ttf";
		CCMenu *menu = [CCMenu menuWithItems: item1, nil];
		[self addChild: menu];        
        
	}
	return self;
}
@end
