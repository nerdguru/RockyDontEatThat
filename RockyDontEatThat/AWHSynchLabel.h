//
//  AWHSynchLabel.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/22/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AWHSynchLabel : CCNode {
    NSMutableArray *labelArray; 
    ccColor3B myBaseColor;
    ccColor3B myHighlightColor;
    int highlightIndex;
}
-(id)initWithLabel:(NSString *)label fontName:(NSString *)fname fontSize:(float)fsize withAnchor:(CGPoint)anchor withBaseColor:(ccColor3B)baseColor withHighlightColor:(ccColor3B)highlightColor withIntervals:(NSArray *)intervalArray;

@end
