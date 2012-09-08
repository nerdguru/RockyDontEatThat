//
//  AWHInstructionsLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AWHInstructionsLayer.h"


@implementation AWHInstructionsLayer


-(id)initWithDict:(NSDictionary *)dict
{
	if(self=[super initWithDict:dict]) {
        
        // Set up sprites
        [self initSpritesArray];
        
        // Set up labels
        [self initLabelsArray];
              
        // Set up Synch Label
        [self initSynchLabel];
        
	}
	return self;
}
@end
