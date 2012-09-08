//
//  AWHGenericLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/2/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import "AWHGenericLayer.h"

@implementation AWHGenericLayer

-(void)startOver {
    [gameStateManager startOver];
}

-(void)nextLevel {
    [gameStateManager gotoNextInstructions];
}

-(id)initWithDict:(NSDictionary *)dict
{
	if(self=[super initWithDict:dict]) {
        
         // Set up sprites
        [self initSpritesArray];
        
        // Temporary restart menu
        CCMenuItemFont *item1 = [CCMenuItemFont itemFromString: @"Start Over" target:self selector:@selector(startOver)];
        item1.color = ccWHITE;
        CCMenuItemFont *item2 = [CCMenuItemFont itemFromString: @"Next Level" target:self selector:@selector(nextLevel)];
        item2.color = ccWHITE;
        item2.position = ccp(0, -50);
		CCMenu *menu = [CCMenu menuWithItems: item1, item2, nil];
		[self addChild: menu];        
        
	}
	return self;
}

@end
