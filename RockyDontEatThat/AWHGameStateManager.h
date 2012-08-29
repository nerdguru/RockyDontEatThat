//
//  AWHGameStateManager.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 8/14/12.
//  Copyright (c) 2012 AppsWithHeart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AWHGameStateManager : NSObject
{
    int currentLevel;
    int removeX;
    int removeY;
    NSString* protagonistEffect;
}
+(id)sharedGameStateManager;
-(int)theCurrentLevel;
-(void)gotoNextLevel;
-(NSDictionary*)getLevelDict;
-(NSArray *) getHighScores;
@property (readwrite, assign) int removeX;
@property (readwrite, assign) int removeY;
@property (readwrite, assign) NSString* protagonistEffect;
@end
