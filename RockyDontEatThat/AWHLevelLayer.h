//
//  AWHLevelLayer.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 8/14/12.
//  Copyright 2012 AppsWithHeart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AWHGameStateManager.h"

@class AWHGameStateManager;
@interface AWHLevelLayer : CCLayerColor {
    AWHGameStateManager *gameStateManager;
    CCLabelTTF *eatenScore;
    CCLabelTTF *remainingFoods;
    CCLabelTTF *remainingCalls;
    NSString* protagonistEffect;
    NSString* scoreEffect;
    AWHSprite* protagonistNormal;
    AWHSprite* protagonistEat;
}
-(void)updateScore:(int)points;
@property (readwrite, assign) NSString* protagonistEffect;
@property (readwrite, assign) NSString* scoreEffect;
@property (readwrite, assign) AWHSprite* protagonistNormal;
@property (readwrite, assign) AWHSprite* protagonistEat;
@end
