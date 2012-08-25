//
//  AWHSynchLabel.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/22/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import "AWHSynchLabel.h"
#import "SimpleAudioEngine.h"


@implementation AWHSynchLabel

-(void) highlightColorAll {
    for (CCLabelTTF* label in labelArray ){
        label.color = myHighlightColor;
    }    
}

-(void) baseColorAll {
    for (CCLabelTTF* label in labelArray ){
        label.color = myBaseColor;
    }   
}
-(void) toggleColor {
    
    // Only toggle the color if there are items in the array left to toggle
    if (highlightIndex < labelArray.count) {
        // Obtain and toggle on the current label in the array
        CCLabelTTF *currentLabel = [labelArray objectAtIndex:highlightIndex];
        currentLabel.color = myHighlightColor;
        
        // Unless this is the first label, toggle off the previous label in the array
        if (highlightIndex > 0) {
            CCLabelTTF *currentLabel = [labelArray objectAtIndex:highlightIndex-1];
            currentLabel.color = myBaseColor;
        }
        highlightIndex++;
    } else {
        // Toggle off the last item
        CCLabelTTF *currentLabel = [labelArray objectAtIndex:highlightIndex-1];
        currentLabel.color = myBaseColor;
    }
}

// Note that initWithLabel assumes an Anchor (meaning bottom left) not a position (meaning center of the whole object)
-(id)initWithLabel:(NSString *)label fontName:(NSString *)fname fontSize:(float)fsize withAnchor:(CGPoint)anchor withBaseColor:(ccColor3B)baseColor withHighlightColor:(ccColor3B)highlightColor withIntervals:(NSArray *)intervalArray {
    self = [super init];
    if (self) {
        
        
        // Save off the anchor position and the colors for later use
        float cumulativeX = anchor.x;
        myBaseColor = baseColor;
        myHighlightColor = highlightColor;
        
        // Separate the words in the label and compute the width of the space
        NSArray *words = [label componentsSeparatedByString:@" "];
        CCLabelTTF *spaceLabel = [CCLabelTTF labelWithString:@" " fontName:fname fontSize:fsize];
        float spaceWidth = spaceLabel.textureRect.size.width*1.4; // Not sure why 1.4 multiplier is needed
        

        // Now iterate through creating the labels and save them off in the labelArray
        labelArray = [[NSMutableArray alloc] initWithCapacity:words.count];
        for (NSString* word in words ){
            // Create a CCLabelTTF for each word and add to both the node children and the labelArray
            CCLabelTTF *currentLabel = [CCLabelTTF labelWithString:word fontName:fname fontSize:fsize];
            currentLabel.anchorPoint=ccp(0,0);
            currentLabel.position = ccp (cumulativeX, anchor.y);
            currentLabel.color = myBaseColor;
            cumulativeX += currentLabel.contentSize.width + spaceWidth;
            [labelArray addObject:currentLabel];
            [self addChild: currentLabel];
        }
        
        // Finally, set up the timings
        highlightIndex = 0;
        float cumulativeTime = 0;
        NSMutableArray *actionsArray = [[NSMutableArray alloc] initWithCapacity:(intervalArray.count*2)];
        for (NSString* intervalString in intervalArray ){
            float intervalFloat = [intervalString floatValue];
            //NSLog(@"intervalFloat: %f cumulativeTime %f delta: %f", intervalFloat, cumulativeTime, intervalFloat-cumulativeTime);
            [actionsArray addObject:[CCDelayTime actionWithDuration: intervalFloat-cumulativeTime]];
            [actionsArray addObject:[CCCallFunc actionWithTarget:self selector:@selector(toggleColor)]];
            cumulativeTime =intervalFloat;
        }
        [self runAction:[CCSequence actionsWithArray:actionsArray]];

    }
    return self;
}

@end
