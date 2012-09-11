//
//  AWHGoodExitLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/9/12.
//  Copyright 2012 AppsWithHeart. All rights reserved.
//

#import "AWHGoodExitLayer.h"
#import "AWHSprite.h"


@implementation AWHGoodExitLayer

-(void)addBonus {
    if (gameStateManager.numLivesLeft == 0)
        [self unschedule:@selector(addTotal)];
    else {
        gameStateManager.numLivesLeft--;
        gameStateManager.totalScore = gameStateManager.totalScore + 10;
        [remainingCalls setString:[NSString stringWithFormat:@"%d", gameStateManager.levelScore]];
        [totalScore setString:[NSString stringWithFormat:@"%d", gameStateManager.totalScore]];
    }
}
-(void)bonusDelay {
    [self unschedule:@selector(bonusDelay)];
    [self schedule:@selector(addBonus) interval:scoreInterval];
}
-(void)addTotal {
    
    gameStateManager.levelScore--;
    gameStateManager.totalScore++;
    [levelScore setString:[NSString stringWithFormat:@"%d", gameStateManager.levelScore]];
    [totalScore setString:[NSString stringWithFormat:@"%d", gameStateManager.totalScore]];
    if(gameStateManager.levelScore == 0)
        [self unschedule:@selector(addTotal)];
    
    if(gameStateManager.levelScore == 0 && [gameStateManager isLastLevel])
        // Bonus processing
        [self schedule:@selector(bonusDelay) interval:1.0];
    
}
-(void)firstDelay {
    [self unschedule:@selector(firstDelay)];
    [self schedule:@selector(addTotal) interval:scoreInterval];
}
-(void)gotoGameOver {
    [self unschedule:@selector(gotoGameOver)];
    [gameStateManager gameOver];
}

-(id)initWithDict:(NSDictionary *)dict
{
	if(self=[super initWithDict:dict]) {
        
        NSDictionary *hudDict = [dict objectForKey:@"HUD"];
        
        if(![gameStateManager isLastLevel])
            // Set up sprites
            [self initSpritesArray];
        else
            [self schedule:@selector(gotoGameOver) interval:[[hudDict objectForKey:@"GameOverDelay"] intValue]];
        // Load up the HUD
        
        AWHSprite *callsSprite=[[AWHSprite alloc] initWithDict:[hudDict objectForKey:@"Sprite"]];
        [self addChild:callsSprite];
        [callsSprite release];
        
        // Level Score Labels
		CCLabelTTF *eatenLabel = [CCLabelTTF labelWithString:[hudDict objectForKey:@"ScoreLabel"] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];
        [eatenLabel setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])];
		eatenLabel.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"ScorePositionX"] intValue] andY:[[hudDict objectForKey:@"ScorePositionY"] intValue]];
		[self addChild: eatenLabel];
        
        levelScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", gameStateManager.levelScore] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];
        [levelScore setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])]; 
		levelScore.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"ScorePositionX"] intValue]+ [[hudDict objectForKey:@"ScoreSpace"] intValue] andY:[[hudDict objectForKey:@"ScorePositionY"] intValue]];
		[self addChild: levelScore];
        
        CCLabelTTF *callsLabel = [CCLabelTTF labelWithString:@"x" fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];        
        [callsLabel setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])];
		callsLabel.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"CallsPositionX"] intValue] andY:[[hudDict objectForKey:@"CallsPositionY"] intValue]];
		[self addChild: callsLabel];
        
        remainingCalls = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", gameStateManager.numLivesLeft] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];
        [remainingCalls setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])]; 
		remainingCalls.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"CallsPositionX"] intValue] + [[hudDict objectForKey:@"CallsSpace"] intValue]  andY:[[hudDict objectForKey:@"CallsPositionY"] intValue]];
		[self addChild: remainingCalls];
        
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
