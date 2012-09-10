//
//  AWHGameStateManager.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 8/14/12.
//  Copyright (c) 2012 AppsWithHeart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AWHResourceManager.h"

@class AWHMainLevelLayer;
@interface AWHGameStateManager : NSObject
{
    AWHResourceManager *resourceManager;
    
    int currentLevel;

    int spritesCounter;
    int activeSprites;
    int numLivesLeft;
    AWHMainLevelLayer* currentLevelLayer;
    int levelScore;
    int totalScore;
}
// Instance Methods
+(id)sharedGameStateManager;
+(CCScene *) scene;

// State control methods
-(void)gotoNextLevel;
-(void)gotoNextInstructions;
-(void)startOver;
-(void)badExit: (NSString*)fileName;
-(void)detectGoodExit;
-(void)gameOver;

// Data access methods
-(NSDictionary*)getLevelDict;
-(NSArray *) getHighScores;
-(BOOL)isLastLevel;

// Pass through to the active level methods
-(void)playProtagonistEffect;
-(int)removeX;
-(int)removeY;
-(void)showNormalProtagonist;
-(void)showEatProtagonist;
-(void)awardPoints: (int)points;

@property (readwrite, assign) int spritesCounter;
@property (readwrite, assign) int activeSprites;
@property (readwrite, assign) int numLivesLeft;
@property (readwrite, assign) int totalScore;
@property (readwrite, assign) int levelScore;
@end
