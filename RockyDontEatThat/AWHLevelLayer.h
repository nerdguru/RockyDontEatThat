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

@interface AWHLevelLayer : CCLayerColor {
    AWHGameStateManager *gameStateManager;
    CCLabelTTF *eatenScore;
    CCLabelTTF *remainingFoods;
    CCLabelTTF *remainingCalls;
}

@end
