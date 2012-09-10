//
//  AWHGameOverLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 9/8/12.
//  Copyright 2012 AppsWithHeart. All rights reserved.
//

#import "AWHGameOverLayer.h"


@implementation AWHGameOverLayer

-(id)initWithDict:(NSDictionary *)dict
{
	if(self=[super initWithDict:dict]) {
        
        // Set up sprites
        [self initSpritesArray];
        
        // Set up labels
        [self initLabelsArray];
        
        // Load up the HUD
        NSDictionary *hudDict = [dict objectForKey:@"HUD"];
        
        // Total Score Labels
        CCLabelTTF *totalScoreLabel = [CCLabelTTF labelWithString:[hudDict objectForKey:@"TotalScoreLabel"] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];        
        [totalScoreLabel setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])];
		totalScoreLabel.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"TotalScorePositionX"] intValue] andY:[[hudDict objectForKey:@"TotalScorePositionY"] intValue]];
		[self addChild: totalScoreLabel];
        
        CCLabelTTF *totalScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", gameStateManager.totalScore] fontName:[hudDict objectForKey:@"Font"] fontSize:[scaleManager scaleFontSize:[[hudDict objectForKey:@"FontSize"] intValue]] ];
        [totalScore setColor:ccc3([[hudDict objectForKey:@"FontColorR"] intValue], [[hudDict objectForKey:@"FontColorG"] intValue], [[hudDict objectForKey:@"FontColorB"] intValue])]; 
		totalScore.position =  [scaleManager scalePointX:[[hudDict objectForKey:@"TotalScorePositionX"] intValue]+ [[hudDict objectForKey:@"TotalScoreSpace"] intValue] andY:[[hudDict objectForKey:@"TotalScorePositionY"] intValue]];
		[self addChild: totalScore];
        
	}
	return self;
}

@end
