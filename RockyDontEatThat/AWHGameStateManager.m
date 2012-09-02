//
//  AWHGameStateManager.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 8/14/12.
//  Copyright (c) 2012 AppsWithHeart. All rights reserved.
//

#import "AWHGameStateManager.h"
#import "AWHHomeLayer.h"
#import "AWHResourceManager.h"
#import "SimpleAudioEngine.h"
#import "AWHLevelLayer.h"

@implementation AWHGameStateManager
@synthesize removeX;
@synthesize removeY;
@synthesize spritesCounter;
@synthesize numLivesLeft;

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
        numLivesLeft=3;
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
    currentLevelLayer = [AWHLevelLayer node];
    [scene addChild: currentLevelLayer];
    levelScore = 0;
    
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

-(void)playProtagonistEffect {
    [[SimpleAudioEngine sharedEngine] playEffect:currentLevelLayer.protagonistEffect];
}
-(void)enableRestartMenu {
    if(spritesCounter == 0) {
        currentLevelLayer.restartMenu.visible = YES;
    }
}
-(void)showNormalProtagonist {
    currentLevelLayer.protagonistEat.visible = NO;
    currentLevelLayer.protagonistNormal.visible = YES;
}
-(void)showEatProtagonist {
    currentLevelLayer.protagonistNormal.visible = NO;
    currentLevelLayer.protagonistEat.visible = YES;
}
-(void)awardPoints: (int)points{
    levelScore += points;
    [currentLevelLayer updateScore:levelScore];
    [[SimpleAudioEngine sharedEngine] playEffect:currentLevelLayer.scoreEffect];
}
@end
