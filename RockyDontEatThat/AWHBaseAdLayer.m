//
//  AWHBaseAdLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/6/12.
//  Copyright 2012 AppsWithHeart. All rights reserved.
//

#import "AWHBaseAdLayer.h"
#import "CCAnimate+SequenceLoader.h"


@implementation AWHBaseAdLayer
@synthesize adWhirlView;

// Original AdWhirl integration code from:
// http://www.raywenderlich.com/5350/how-to-integrate-adwhirl-into-a-cocos2d-game

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	self.adWhirlView.delegate = nil;
    self.adWhirlView = nil;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void)adWhirlWillPresentFullScreenModal {
}

- (void)adWhirlDidDismissFullScreenModal {
}

- (NSString *)adWhirlApplicationKey {
    return @"ed84628313c54d739a528136cf4c6914";
}

- (UIViewController *)viewControllerForPresentingModalView {
    return viewController;    
}

-(void)adjustAdSize {
	[UIView beginAnimations:@"AdResize" context:nil];
	[UIView setAnimationDuration:0.2];
	
	CGSize adSize = [adWhirlView actualAdSize];
	CGRect newFrame = adWhirlView.frame;
	newFrame.size.height = adSize.height;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
	newFrame.size.width = winSize.width;
    newFrame.origin.x = (self.adWhirlView.bounds.size.width - adSize.width-[scaleManager scaleAdPadding]);
	newFrame.origin.y = (winSize.height - adSize.height-[scaleManager scaleAdOriginY]-[scaleManager scaleAdPadding]);
    
	adWhirlView.frame = newFrame;
	[UIView commitAnimations];
}

- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlVieww {
    [adWhirlView rotateToOrientation:UIInterfaceOrientationLandscapeRight];
    [self adjustAdSize];
}

-(void)onEnter {
    viewController = [(AppDelegate *)[[UIApplication sharedApplication] delegate] viewController];
    self.adWhirlView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
    self.adWhirlView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [adWhirlView updateAdWhirlConfig];
    
	CGSize adSize = [adWhirlView actualAdSize];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // Original code commented out to center the ad
	//self.adWhirlView.frame = CGRectMake((winSize.width/2)-(adSize.width/2),winSize.height-adSize.height,winSize.width,adSize.height);
    self.adWhirlView.frame = CGRectMake((winSize.width)-(adSize.width)-[scaleManager scaleAdPadding],winSize.height-adSize.height-[scaleManager scaleAdOriginY]-[scaleManager scaleAdPadding],winSize.width,adSize.height);
	self.adWhirlView.clipsToBounds = YES;
    
    [viewController.view addSubview:adWhirlView];
    [viewController.view bringSubviewToFront:adWhirlView];
    [super onEnter];
}

-(void)onExit {
    if (adWhirlView) {
        [adWhirlView removeFromSuperview];
        [adWhirlView replaceBannerViewWith:nil];
        [adWhirlView ignoreNewAdRequests];
        [adWhirlView setDelegate:nil];
        self.adWhirlView = nil;
    }
	[super onExit];
}

@end
