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
#import "AWHMainLevelLayer.h"
#import "AWHInstructionsLayer.h"
#import "AWHBadExitLayer.h"
#import "AWHGoodExitLayer.h"
#import "AWHGameOverLayer.h"
#import "AWHGenericLayer.h"

@implementation AWHGameStateManager

@synthesize spritesCounter;
@synthesize activeSprites;
@synthesize numLivesLeft;
@synthesize totalScore;
@synthesize levelScore;

// Singleton accessor method
+ (id)sharedGameStateManager {
    static id sharedGameStateManager = nil;
    
    if (sharedGameStateManager == nil) {
        sharedGameStateManager = [[self alloc] init];
    }
    
    return sharedGameStateManager;
}

+(CCScene *) scene
{
    // Get the correct dict
    AWHResourceManager *resourceManager = [AWHResourceManager sharedResourceManager];
    NSDictionary *dict = [resourceManager levelDictionaryWithIndex:0];
    NSDictionary *levelDict = [dict objectForKey:@"Level"];
    
    // Create autorelease objects
    CCScene *scene = [CCScene node];
    AWHHomeLayer *layer = [[AWHHomeLayer alloc] initWithDict:levelDict];
    [scene addChild: layer];
    [layer release];
	
	// return the scene 
	return scene;
}

-(id)init {
    if( (self=[super init]) ) {
        currentLevel = 0;
        numLivesLeft = 3;
        totalScore = 0;
        resourceManager = [AWHResourceManager sharedResourceManager];
    }
    return self;
    
}

// Logic for incrementing the level state and swapping in the new scene
-(void)gotoNextLevel {

    // Stop the background music
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    // Get the correct dict
    
    levelScore = 0;
    NSDictionary *dict = [resourceManager levelDictionaryWithIndex:currentLevel];
    NSDictionary *levelDict = [dict objectForKey:@"Level"];
    
    // Create autorelease objects
    CCScene *scene = [CCScene node];
    currentLevelLayer = [[AWHMainLevelLayer alloc] initWithDict:levelDict];
    [scene addChild: currentLevelLayer];
    [currentLevelLayer release];
    
    // Replace the scene
    
    [[CCDirector sharedDirector] replaceScene:scene];
}

// Logic for incrementing the level state and swapping in the new scene
-(void)gotoNextInstructions {
    
    // Stop the background music
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    // Get the correct dict
    currentLevel++;
    NSDictionary *dict = [resourceManager levelDictionaryWithIndex:currentLevel];
    NSDictionary *instructionsDict = [dict objectForKey:@"Instructions"];
    
    // Create autorelease objects
    CCScene *scene = [CCScene node];
    AWHInstructionsLayer* layer = [[AWHInstructionsLayer alloc] initWithDict:instructionsDict];
    [scene addChild: layer];
    [layer release];
    
    // Replace the scene
    
    [[CCDirector sharedDirector] replaceScene:scene];
}

// Logic for incrementing the level state and swapping in the new scene
-(void)startOver {
    
    currentLevel = 0;
    numLivesLeft = 3;
    totalScore = 0;
    
    // Get the correct dict
    NSDictionary *dict = [resourceManager levelDictionaryWithIndex:currentLevel];
    NSDictionary *levelDict = [dict objectForKey:@"Level"];
    
    // Create autorelease objects
    CCScene *scene = [CCScene node];
    AWHHomeLayer *layer = [[AWHHomeLayer alloc] initWithDict:levelDict];
    [scene addChild: layer];
    [layer release];
   
    // Replace the scene
    [[CCDirector sharedDirector] replaceScene:scene];
}

// Logic for incrementing the level state and swapping in the new scene
-(void)gameOver {
    
    currentLevel = 0;
    
    // Get the correct dict
    NSDictionary *dict = [resourceManager levelDictionaryWithIndex:currentLevel];
    NSDictionary *gameOverDict = [dict objectForKey:@"GameOver"];
    
    // Create autorelease objects
    CCScene *scene = [CCScene node];
    AWHGameOverLayer *layer = [[AWHGameOverLayer alloc] initWithDict:gameOverDict];
    [scene addChild: layer];
    [layer release];
    
    // Replace the scene
    [[CCDirector sharedDirector] replaceScene:scene];
}

// Execute a bad exit
-(void)badExit: (NSString*)fileName {
    
    // Stop the background music
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    // Get the correct dict
    NSDictionary *levelDict = [resourceManager levelDictionaryWithIndex:currentLevel];
    NSDictionary *badExitDict = [levelDict objectForKey:@"BadExit"];

    // Create autorelease objects
    CCScene *scene = [CCScene node];
    AWHBadExitLayer *layer = [[AWHBadExitLayer alloc] initWithDict:badExitDict withFileName:fileName];
    [scene addChild: layer];
    [layer release];
    
    // Replace the scene
    
    [[CCDirector sharedDirector] replaceScene:scene];
}

// Figureout if we've reached a good exit, if so execute
-(void)detectGoodExit {
    activeSprites--;
    if(activeSprites == 0) {
        // Stop the background music
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        // Get the correct dict
        NSDictionary *levelDict = [resourceManager levelDictionaryWithIndex:currentLevel];
        NSDictionary *goodExitDict = [levelDict objectForKey:@"GoodExit"];
        
        // Create autorelease objects
        CCScene *scene = [CCScene node];
        AWHGoodExitLayer *layer = [[AWHGoodExitLayer alloc] initWithDict:goodExitDict];
        [scene addChild: layer];
        [layer release];
        
        // Replace the scene
        
        [[CCDirector sharedDirector] replaceScene:scene];
    }
    
}

// Logic for returning the correct Dictionary
-(NSDictionary*)getLevelDict {
    NSDictionary *groupDict = [resourceManager levelDictionaryWithIndex:currentLevel];
    return [groupDict objectForKey:@"Level"];
}

-(NSArray *) getHighScores {
    return [resourceManager getHighScores];
}
-(BOOL)isLastLevel{
    int ll = [resourceManager lastLevel];
    if(ll == currentLevel)
        return YES;
    else 
        return NO;
}

-(void)playProtagonistEffect {
    [[SimpleAudioEngine sharedEngine] playEffect:currentLevelLayer.protagonistEffect];
}


// Pass through methods to the level layer
-(int)removeX {
    return currentLevelLayer.removeX;
}
-(int)removeY{
    return currentLevelLayer.removeY;
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
