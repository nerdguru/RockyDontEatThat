//
//  AWHMainLevelLayer.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/6/12.
//  Copyright 2012 AppssWithHeart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AWHBaseLayer.h"
#import "AWHSprite.h"

@interface AWHMainLevelLayer : AWHBaseLayer {
    CCLabelTTF *eatenScore;
    CCLabelTTF *remainingFoods;
    CCLabelTTF *remainingCalls;
    
    int removeX;
    int removeY;
    NSString* protagonistEffect;
    NSString* scoreEffect;
    AWHSprite* protagonistNormal;
    AWHSprite* protagonistEat;
}
-(void)updateScore:(int)points;
@property (readwrite, assign) int removeX;
@property (readwrite, assign) int removeY;
@property (readwrite, assign) NSString* protagonistEffect;
@property (readwrite, assign) NSString* scoreEffect;
@property (readwrite, assign) AWHSprite* protagonistNormal;
@property (readwrite, assign) AWHSprite* protagonistEat;
@end
