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
}
+(id)sharedGameStateManager;
-(int)theCurrentLevel;
-(void)gotoNextLevel;
@end
