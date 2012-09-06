//
//  AWHHomeLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/22/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import "AWHHomeLayer.h"

@implementation AWHHomeLayer

-(id) initWithDict:(NSDictionary *)levelDict
{

    if(self=[super initWithDict:levelDict]) {
        
        // Set up sprites
        [self initSpritesArray];
        
        // Set up high scores
        [self initHighScores];
        
        // Set up Synch Label
        [self initSynchLabel];
        
	}
	return self;
}
@end
