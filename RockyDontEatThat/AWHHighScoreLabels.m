//
//  AWHHighScoreLabels.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/29/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import "AWHHighScoreLabels.h"
#import "AWHScaleManager.h"


@implementation AWHHighScoreLabels

-(id)initWithArray:(NSArray *)highScoreArray{
    self = [super init];
    if (self) {
        // Get the ScaleManager
        AWHScaleManager *scaleManager = [AWHScaleManager sharedScaleManager];
        
        // Set the starting height
        float currentY = 245;
        
        // Init the array that tracks the rows
        hiScoreRows = [[NSMutableArray alloc] initWithCapacity:5];
        
        // Init the header
        CCLabelTTF *hsTitleLabel = [CCLabelTTF labelWithString:@"HIGH SCORES" fontName:@"PressStart2P.ttf" fontSize:[scaleManager scaleFontSize:16] ];
        hsTitleLabel.color = ccc3(255, 0, 0);
		hsTitleLabel.position = [scaleManager scalePointX:350 andY:currentY];
		[self addChild: hsTitleLabel];
        
        // Now iterate through and populate
        for (NSDictionary* entryDict in highScoreArray ){
            NSString *name = [entryDict objectForKey:@"name"];
            NSString *score = [entryDict objectForKey:@"score"];
            currentY -= 20;
            CCLabelTTF *currentHSLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@     %@", name, score] fontName:@"PressStart2P.ttf" fontSize:[scaleManager scaleFontSize:16] ];
            currentHSLabel.color = ccc3(255, 0, 0);
            currentHSLabel.position = [scaleManager scalePointX:350 andY:currentY];
            [hiScoreRows addObject:currentHSLabel];
            [self addChild: currentHSLabel];
        }
    }
    return self;
}

-(void)updateWithArray:(NSArray *)highScoreArray{
    
    
    
}

@end
