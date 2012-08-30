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

@interface AWHGameStateManager : NSObject
{
    int currentLevel;
    int removeX;
    int removeY;
    NSString* protagonistEffect;
    AWHSprite* protagonist;
    AWHSprite* protagonistEat;
    int numSprites;
    CCMenu* restartMenu;
    int counter;
}
+(id)sharedGameStateManager;
-(int)theCurrentLevel;
-(void)gotoNextLevel;
-(void)startOver;
-(NSDictionary*)getLevelDict;
-(NSArray *) getHighScores;
@property (readwrite, assign) int removeX;
@property (readwrite, assign) int removeY;
@property (readwrite, assign) NSString* protagonistEffect;
@property (readwrite, assign) AWHSprite* protagonist;
@property (readwrite, assign) AWHSprite* protagonistEat;
@property (readwrite, assign) int numSprites;
@property (readwrite, assign) CCMenu* restartMenu;
@property (readwrite, assign) int counter;
@end
