//
//  AWHResourceManager.h
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/28/12.
//  Copyright (c) 2012 Apps With Heart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWHResourceManager : NSObject
{
    NSDictionary *resourcesDict;
    NSArray *highScoreArray;
}

+(id)sharedResourceManager;
+(NSDictionary *)expandSpriteDict:(NSDictionary *)dict;
-(NSDictionary *)levelDictionaryWithIndex:(int)index;
-(NSArray *) getHighScores;
-(int)lastLevel;
-(void) saveHighScores;
-(void) deleteHighScores;
-(void) loadHighScoresPlist;
@end
