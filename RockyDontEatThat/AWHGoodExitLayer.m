//
//  AWHGoodExitLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/9/12.
//  Copyright 2012 AppsWithHeart. All rights reserved.
//

#import "AWHGoodExitLayer.h"


@implementation AWHGoodExitLayer

-(void)addTotal {
    
    gameStateManager.levelScore--;
    gameStateManager.totalScore++;
    [levelScore setString:[NSString stringWithFormat:@"%d", gameStateManager.levelScore]];
    [totalScore setString:[NSString stringWithFormat:@"%d", gameStateManager.totalScore]];
    if(gameStateManager.levelScore == 0)
        [self unschedule:@selector(addTotal)];
}
-(void)firstDelay {
    [self unschedule:@selector(firstDelay)];
    [self schedule:@selector(addTotal) interval:scoreInterval];
}

-(id)initWithDict:(NSDictionary *)dict
{
	if(self=[super initWithDict:dict]) {
        
        // Set up sprites
        [self initSpritesArray];
        
        // Load up the HUD
        NSDictionary *hudDict = [dict objectForKey:@"HUD"];
        
        // Level Score Labels
		CCLabelTTF *eatenLabel = [CCLabelTTF labelWithString:[hudDict objectForKey:@"ScoreLabel"] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];
        [eatenLabel setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])];
		eatenLabel.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"ScorePositionX"] intValue] andY:[[hudDict objectForKey:@"ScorePositionY"] intValue]];
		[self addChild: eatenLabel];
        
        levelScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", gameStateManager.levelScore] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];
        [levelScore setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])]; 
		levelScore.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"ScorePositionX"] intValue]+ [[hudDict objectForKey:@"ScoreSpace"] intValue] andY:[[hudDict objectForKey:@"ScorePositionY"] intValue]];
		[self addChild: levelScore];
        
        // Total Score Labels
        CCLabelTTF *totalScoreLabel = [CCLabelTTF labelWithString:[hudDict objectForKey:@"TotalScoreLabel"] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];        
        [totalScoreLabel setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])];
		totalScoreLabel.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"TotalScorePositionX"] intValue] andY:[[hudDict objectForKey:@"TotalScorePositionY"] intValue]];
		[self addChild: totalScoreLabel];
        
        totalScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", gameStateManager.totalScore] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];
        [totalScore setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])]; 
		totalScore.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"TotalScorePositionX"] intValue]+ [[hudDict objectForKey:@"TotalScoreSpace"] intValue] andY:[[hudDict objectForKey:@"TotalScorePositionY"] intValue]];
		[self addChild: totalScore];
    
        float firstInterval=2.0;
        NSString* firstDelayString = [dict objectForKey:@"FirstDelay"];
        if(firstDelayString != nil)
            firstInterval = [firstDelayString floatValue];
        [self schedule:@selector(firstDelay) interval:firstInterval];
        
        scoreInterval=0.2;
        NSString* scoreIntervalString = [dict objectForKey:@"ScoreInterval"];
        if(scoreIntervalString != nil)
            scoreInterval = [scoreIntervalString floatValue];
        
        // Set up Synch Label
        [self initSynchLabel];
    
	}
	return self;
}

@end
