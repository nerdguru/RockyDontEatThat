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

-(id)initWithDict:(NSDictionary *)dict
{
	if(self=[super initWithDict:dict]) {
        
         // Set up sprites
        [self initSpritesArray];
        
        // Temporary restart menu
        CCMenuItemFont *item1 = [CCMenuItemFont itemFromString: @"Start Over" target:self selector:@selector(startOver)];
        item1.color = ccWHITE;
		CCMenu *menu = [CCMenu menuWithItems: item1, nil];
		[self addChild: menu];        
        
	}
	return self;
}

@end
