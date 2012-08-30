//
//  AWHGameStateManager.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 8/14/12.
//  Copyright (c) 2012 AppsWithHeart. All rights reserved.
//

#import "AWHGameStateManager.h"
#import "AWHLevelLayer.h"
#import "AWHHomeLayer.h"
#import "AWHResourceManager.h"
#import "SimpleAudioEngine.h"

@implementation AWHGameStateManager
@synthesize removeX;
@synthesize removeY;
@synthesize protagonistEffect;
@synthesize protagonist;
@synthesize protagonistEat;
@synthesize numSprites;
@synthesize restartMenu;
@synthesize counter;

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

// Logic for incrementing the level state and swapping in the new scene
-(void)gotoNextLevel {
    
    // Increment the level
    currentLevel++;
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    // Create autorelease objects
    CCScene *scene = [CCScene node];
    AWHLevelLayer *layer = [AWHLevelLayer node];
    [scene addChild: layer];
    
    
    // Replace the scene

    [[CCDirector sharedDirector] replaceScene:scene];
}

// Logic for incrementing the level state and swapping in the new scene
-(void)startOver {
    
    // Increment the level
    currentLevel = 0;
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    // Create autorelease objects
    CCScene *scene = [CCScene node];
    AWHHomeLayer *layer = [AWHHomeLayer node];
    [scene addChild: layer];
    
    // Replace the scene
    
    [[CCDirector sharedDirector] replaceScene:scene];
}

// Logic for returning the correct Dictionary
-(NSDictionary*)getLevelDict {
    AWHResourceManager *resourceManager = [AWHResourceManager sharedResourceManager];
    NSDictionary *groupDict = [resourceManager levelDictionaryWithIndex:currentLevel];
    return [groupDict objectForKey:@"Level"];
}

-(NSArray *) getHighScores {
    AWHResourceManager *resourceManager = [AWHResourceManager sharedResourceManager];
    return [resourceManager getHighScores];
}
@end
