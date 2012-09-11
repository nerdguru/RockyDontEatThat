//
//  AWHGoodExitLayer.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/9/12.
//  Copyright 2012 AppsWithHeart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AWHBaseLayer.h"

@interface AWHGoodExitLayer : AWHBaseLayer {
    CCLabelTTF *levelScore;
    CCLabelTTF *totalScore;
    CCLabelTTF *remainingCalls;
    float scoreInterval;
}

@end
