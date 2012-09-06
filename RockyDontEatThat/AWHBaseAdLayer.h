//
//  AWHBaseAdLayer.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/6/12.
//  Copyright 2012 AppsWithHeart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AdWhirlView.h"
#import "AdWhirlDelegateProtocol.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "AWHBaseLayer.h"

@interface AWHBaseAdLayer : AWHBaseLayer <AdWhirlDelegate>{
    // Needed for AdWhirl
    // See http://www.raywenderlich.com/5350/how-to-integrate-adwhirl-into-a-cocos2d-game
    RootViewController *viewController;
    AdWhirlView *adWhirlView;
}
// Needed for AdWhirl
@property(nonatomic,retain) AdWhirlView *adWhirlView;

@end
