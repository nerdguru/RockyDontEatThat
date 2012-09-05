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

@interface AWHBaseLayer : CCLayerColor {
    AWHGameStateManager *gameStateManager;
    AWHScaleManager *scaleManager;
}

@end
