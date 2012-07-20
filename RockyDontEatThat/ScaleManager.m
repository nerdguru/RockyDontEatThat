//
//  ScaleManager.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/19/12.
//  Copyright (c) 2012 Apps With Heart. All rights reserved.
//

#import "ScaleManager.h"

@implementation ScaleManager

+ (id)sharedScaleManager {
    static id sharedScaleManager = nil;
    
    if (sharedScaleManager == nil) {
        sharedScaleManager = [[self alloc] init];
    }
    
    return sharedScaleManager;
}

-(id) init
{
	if( (self=[super init]) ) {
        // Logic adapted from
        // http://craigmcfarlaneoz.wordpress.com/2012/03/09/cocos2d-detecting-iphone-iphone-hd-ipad-and-ipad-hd/
        
        //Grab the screens scale factor – 1.0 = SD screen & 2.0 = HD screen
        CGFloat deviceScale = [[UIScreen mainScreen] scale];
        
        // Set our internal scale variable relative to a retina display
        if (deviceScale > 1.0) {
            retina = YES;
            NSLog(@"retina: YES");
        } else {
            retina = NO;
            NSLog(@"retina: NO");
        }
        
        //and now we grab the device model 
        NSString* valueDevice = [[UIDevice currentDevice] model];
        if ([valueDevice rangeOfString:@"iPad"].location == NSNotFound)  
            //Test to see if our valueDevice NSString does not contains the substring iPad & if it does not it is an iPhone otherwise it is an iPad             
        {
            iPad = NO;
            NSLog(@"iPad: NO");
        } else {
            iPad = YES;
            NSLog(@"iPad: YES");
        }
	}
	return self;
}

-(CGPoint)scalePointX:(float)x andY:(float)y {
    if (!iPad)
        return ccp(x,y);
    
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    float xOffset = (size.width - 960) / 2;
    float yOffset = (size.height - 640) / 2;
    NSLog(@"xOffset: %f", xOffset);
    NSLog(@"yOffset: %f", yOffset);
    NSLog(@"2*x+xOffset: %f", 2*x+xOffset);
    NSLog(@"2*y+yOffset: %f", 2*y+yOffset);
    return ccp(2*x+xOffset, 2*y+yOffset);
}

-(float)scaleFontSize:(float)size {
    if (!iPad)
        return size;
    else 
        return 2*size;    
}

@end
