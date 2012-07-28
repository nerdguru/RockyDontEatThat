//
//  AWHResourceManager.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/28/12.
//  Copyright (c) 2012 Apps With Heart. All rights reserved.
//

#import "AWHResourceManager.h"

@implementation AWHResourceManager

+ (id)sharedResourceManager {
    static id sharedResourceManager = nil;
    
    if (sharedResourceManager == nil) {
        sharedResourceManager = [[self alloc] init];
    }
    
    return sharedResourceManager;
}

-(id) init
{
	if( (self=[super init]) ) {
    // Load up the Resources.plist 
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"plist"];
        resourcesDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    }
    return self;
}

-(NSDictionary *)levelDictionaryWithIndex:(int)index
{
    NSArray *levelArray = [resourcesDict objectForKey:@"Levels"];
    return [levelArray objectAtIndex:index];
}

@end
