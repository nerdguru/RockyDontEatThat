//
//  AWHScaleManager.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/19/12.
//  Copyright (c) 2012 Apps With Heart. All rights reserved.
//

#import "cocos2d.h"

@interface AWHScaleManager : NSObject
{
    BOOL iPad;
    BOOL retina;
}
+(id)sharedScaleManager;
-(CGPoint)scalePointX:(float)x andY:(float)y; 
-(float)scaleFontSize:(float)size;
-(float)scaleImage;
@end
