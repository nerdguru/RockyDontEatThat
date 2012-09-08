//
//  AWHGameOverLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/8/12.
//  Copyright 2012 AppsWithHeart. All rights reserved.
//

#import "AWHGameOverLayer.h"


@implementation AWHGameOverLayer

-(id)initWithDict:(NSDictionary *)dict
{
	if(self=[super initWithDict:dict]) {
        
        // Set up sprites
        [self initSpritesArray];
        
        // Set up labels
        [self initLabelsArray];
        
	}
	return self;
}

@end
