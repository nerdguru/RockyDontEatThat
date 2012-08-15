//
//  AWHGameStateManager.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 8/14/12.
//  Copyright (c) 2012 AppsWithHeart. All rights reserved.
//

#import "AWHGameStateManager.h"
#import "AWHLevelLayer.h"

@implementation AWHGameStateManager

// Singleton accessor method
+ (id)sharedGameStateManager {
    static id sharedGameStateManager = nil;
    
    if (sharedGameStateManager == nil) {
        sharedGameStateManager = [[self alloc] init];
    }
    
    return sharedGameStateManager;
}

-(id)init {
    if( (self=[super init]) ) {
        currentLevel = 0;
    }
    return self;
    
}

-(int)theCurrentLevel {
    return currentLevel;
}

-(void)gotoNextLevel {
    
    // Increment the level
    currentLevel++;
    
    // Create autorelease objects
    CCScene *scene = [CCScene node];
    AWHLevelLayer *layer = [AWHLevelLayer node];
    [scene addChild: layer];
    
    // Replace the scene

    [[CCDirector sharedDirector] replaceScene:scene];
}
@end
