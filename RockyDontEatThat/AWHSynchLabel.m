//
//  AWHSynchLabel.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/22/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import "AWHSynchLabel.h"


@implementation AWHSynchLabel

-(void) highlightColor {
    for (CCLabelTTF* label in labelArray ){
        label.color = myHighlightColor;
    }    
}

-(void) baseColor {
    for (CCLabelTTF* label in labelArray ){
        label.color = myBaseColor;
    }   
}

-(id)initWithLabel:(NSString *)label fontName:(NSString *)fname fontSize:(float)fsize withAnchor:(CGPoint)anchor withBaseColor:(ccColor3B)baseColor withHighlightColor:(ccColor3B)highlightColor{
    self = [super init];
    if (self) {
        
        float cumulativeX = anchor.x;
        float cumulativeY = anchor.y;
        myBaseColor = baseColor;
        myHighlightColor = highlightColor;
        
        // Separate the words in the label and iterate through them
        NSArray *words = [label componentsSeparatedByString:@" "];
        CCLabelTTF *spaceLabel = [CCLabelTTF labelWithString:@" " fontName:fname fontSize:fsize];
        float spaceWidth = spaceLabel.textureRect.size.width*1.4;
        

        labelArray = [[NSMutableArray alloc] initWithCapacity:words.count];
        for (NSString* word in words ){
            // Create a CCLabelTTF for each word and add to both the node children and the labelArray
            CCLabelTTF *currentLabel = [CCLabelTTF labelWithString:word fontName:fname fontSize:fsize];
            currentLabel.anchorPoint=ccp(0,0);
            currentLabel.position = ccp (cumulativeX, cumulativeY);
            currentLabel.color = myBaseColor;
            cumulativeX += currentLabel.contentSize.width + spaceWidth;
            [labelArray addObject:currentLabel];
            id delay = [CCDelayTime actionWithDuration: 2.0];
            id callback1=[CCCallFunc actionWithTarget:self selector:@selector(highlightColor)];
            id callback2=[CCCallFunc actionWithTarget:self selector:@selector(baseColor)];
            [currentLabel runAction:[CCSequence actions:delay, callback1, delay, callback2, nil]];

            [self addChild: currentLabel];
            NSLog(@"Word |%@| Width: %f Height %f X: %f Y %f", word, currentLabel.contentSize.width, currentLabel.contentSize.height, currentLabel.position.x, currentLabel.position.y);
        }

    }
    return self;
}

@end
