//
//  AWHHomeLayer.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/22/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AdWhirlView.h"
#import "AdWhirlDelegateProtocol.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "AWHBaseLayer.h"

@interface AWHHomeLayer : AWHBaseLayer <AdWhirlDelegate>
{

    // Needed for AdWhirl
    // See http://www.raywenderlich.com/5350/how-to-integrate-adwhirl-into-a-cocos2d-game
    RootViewController *viewController;
    AdWhirlView *adWhirlView;
}
+(CCScene *) scene;

// Needed for AdWhirl
@property(nonatomic,retain) AdWhirlView *adWhirlView;
@end
