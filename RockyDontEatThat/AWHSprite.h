//
//  AWHSprite.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/28/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AWHSprite : CCNode <CCTargetedTouchDelegate> {
    CCSprite *mySprite;
    BOOL beenTouched;
    NSArray *touchReactions;
    NSDictionary *originalActions;
    int value;
    BOOL beenEaten;
    NSString* fileName;
}
@property (nonatomic, retain) CCSprite *mySprite;
-(id)initWithDict:(NSDictionary *)spriteDict;
-(CCAction *)processActions:(NSDictionary *)action;

@end
