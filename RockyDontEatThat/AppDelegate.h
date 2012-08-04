//
//  AppDelegate.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/17/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;
// Needed for AdWhirl
@property (nonatomic, retain) RootViewController *viewController;

@end
