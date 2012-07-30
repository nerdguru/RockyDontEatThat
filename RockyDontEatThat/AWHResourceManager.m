//
//  AWHResourceManager.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/28/12.
//  Copyright (c) 2012 Apps With Heart. All rights reserved.
//

#import "AWHResourceManager.h"

@implementation AWHResourceManager

+ (id)sharedResourceManager {
    static id sharedResourceManager = nil;
    
    if (sharedResourceManager == nil) {
        sharedResourceManager = [[self alloc] init];
    }
    
    return sharedResourceManager;
}

-(id) init
{
	if( (self=[super init]) ) {
    // Load up the Resources.plist 
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"plist"];
        resourcesDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        
    // Load up the high scoresfrom user data or high-scores.plist
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        highScoreArray=[ud objectForKey:@"myScores"];
        
        if(highScoreArray == nil) {
            filePath = [[NSBundle mainBundle] pathForResource:@"high-scores" ofType:@"plist"];
            NSDictionary *highScoreDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
            highScoreArray = [highScoreDict objectForKey:@"scores"];
        }
    }
    return self;
}

-(NSDictionary *)levelDictionaryWithIndex:(int)index
{
    NSArray *levelArray = [resourcesDict objectForKey:@"Levels"];
    return [levelArray objectAtIndex:index];
}

-(NSArray *) getHighScores {
    return highScoreArray;
}

-(void) saveHighScores {
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:highScoreArray forKey:@"myScores"];
    [ud synchronize];
}

-(void) deleteHighScores {
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"myScores"];
    [ud synchronize];
}

-(void) loadHighScoresPlist{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"high-scores" ofType:@"plist"];
    NSDictionary *highScoreDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    highScoreArray = [highScoreDict objectForKey:@"scores"];
}

@end
