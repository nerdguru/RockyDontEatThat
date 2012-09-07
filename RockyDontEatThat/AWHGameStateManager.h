//
//  AWHGameStateManager.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 8/14/12.
//  Copyright (c) 2012 AppsWithHeart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AWHSprite.h"

@class AWHMainLevelLayer;
@interface AWHGameStateManager : NSObject
{
    int currentLevel;

    int spritesCounter;
    int activeSprites;
    int numLivesLeft;
    AWHMainLevelLayer* currentLevelLayer;
    int levelScore;
}
// Instance Methods
+(id)sharedGameStateManager;
+(CCScene *) scene;

// State control methods
-(void)gotoNextLevel;
-(void)startOver;
-(void)badExit;
-(void)detectGoodExit;

// Data access methods
-(NSDictionary*)getLevelDict;
-(NSArray *) getHighScores;

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
@end
