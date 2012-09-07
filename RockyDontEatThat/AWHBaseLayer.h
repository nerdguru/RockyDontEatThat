//
//  AWHBaseLayer.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/5/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AWHGameStateManager.h"
#import "AWHScaleManager.h"

@class AWHGameStateManager;
@interface AWHBaseLayer : CCLayerColor {
    AWHGameStateManager *gameStateManager;
    AWHScaleManager *scaleManager;
    NSString* backgroundMusic;
    NSDictionary *myDict;
}
-(id)initWithDict:(NSDictionary *)layerDict;
-(void)initSpritesArray;
-(void)initSynchLabel;
-(void)initHighScores;
-(void)initLabelsArray;
@end
