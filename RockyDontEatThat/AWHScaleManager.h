//
//  AWHScaleManager.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/19/12.
//  Copyright (c) 2012 Apps With Heart. All rights reserved.
//

#import "cocos2d.h"

/*
 * AWHScaleManager is used to handle all the universal app scaling needs and helps create a centered
 * letterbox given the different aspect ratios of iPhone vs iPad
 */

@interface AWHScaleManager : NSObject
{
    BOOL iPad;
    BOOL retina;
}
+(id)sharedScaleManager;
-(CGPoint)scalePointX:(float)x andY:(float)y; 
-(float)scaleFontSize:(float)size;
-(float)scaleImage;
-(float)scaleAd;
-(CGRect)scaledAdFrame;
-(CGSize)scaledAdSize;
-(float)scaleAdOriginY;
@end
