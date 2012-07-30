//
//  AWHHighScoreLabels.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/29/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AWHHighScoreLabels : CCNode {
    NSMutableArray *hiScoreRows;
}
-(id)initWithArray:(NSArray *)highScoreArray;
-(void)updateWithArray:(NSArray *)highScoreArray;

@end
