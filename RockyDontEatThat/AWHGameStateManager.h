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
#import "AWHLevelLayer.h"

@class AWHLevelLayer;
@interface AWHGameStateManager : NSObject
{
    int currentLevel;
    int removeX;
    int removeY;
    int spritesCounter;
    int activeSprites;
    int numLivesLeft;
    AWHLevelLayer* currentLevelLayer;
    int levelScore;
}
+(id)sharedGameStateManager;
-(int)theCurrentLevel;
-(void)gotoNextLevel;
-(void)startOver;
-(NSDictionary*)getLevelDict;
-(NSArray *) getHighScores;
-(void)playProtagonistEffect;
-(void)enableRestartMenu;
-(void)showNormalProtagonist;
-(void)showEatProtagonist;
-(void)awardPoints: (int)points;
@property (readwrite, assign) int removeX;
@property (readwrite, assign) int removeY;
@property (readwrite, assign) int spritesCounter;
@property (readwrite, assign) int activeSprites;
@property (readwrite, assign) int numLivesLeft;
@end
