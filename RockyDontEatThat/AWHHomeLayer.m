//
//  AWHHomeLayer.m
//  RockyDontEatThat
//
//  Created by Pete Johnson on 7/22/12.
//  Copyright 2012 Apps With Heart. All rights reserved.
//

#import "AWHHomeLayer.h"
#import "SimpleAudioEngine.h"
#import "CCAnimate+SequenceLoader.h"
#import "AWHScaleManager.h"
#import "AWHResourceManager.h"
#import "AWHGameStateManager.h"
#import "AWHSynchLabel.h"
#import "AWHSprite.h"
#import "AWHHighScoreLabels.h"


@implementation AWHHomeLayer
@synthesize adWhirlView;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	//CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	//AWHHomeLayer *layer = [AWHHomeLayer node];
    // Get the correct dict
    AWHResourceManager *resourceManager = [AWHResourceManager sharedResourceManager];
    NSDictionary *dict = [resourceManager levelDictionaryWithIndex:0];
    NSDictionary *levelDict = [dict objectForKey:@"Level"];
    
    // Create autorelease objects
    CCScene *scene = [CCScene node];
    AWHHomeLayer *layer = [[AWHHomeLayer alloc] initWithDict:levelDict];
    [scene addChild: layer];
    [layer release];

	
	// add layer as a child to scene
	//[scene addChild: layer];
	
	// return the scene 
	return scene;
}

// on "init" you need to initialize your instance
-(id) initWithDict:(NSDictionary *)levelDict
{
    /*
    // Start up the ResourceManager and get/apply the background colors
    AWHGameStateManager *gameStateManager = [AWHGameStateManager sharedGameStateManager];
    
	//NSDictionary *levelDict = [gameStateManager getLevelDict];
    NSDictionary *backgroundDict = [levelDict objectForKey:@"Background"];
	if( (self=[super initWithColor:ccc4([[backgroundDict objectForKey:@"Red"] intValue], 
                                        [[backgroundDict objectForKey:@"Green"] intValue], 
                                        [[backgroundDict objectForKey:@"Blue"] intValue], 
                                        [[backgroundDict objectForKey:@"Opacity"] intValue])])) {
	*/	
    if(self=[super initWithDict:levelDict]) {
        // Get the ScaleManager
        //AWHScaleManager *scaleManager = [AWHScaleManager sharedScaleManager]; 
        
        // Place animated title label
        ccColor3B rockyBrown = ccc3(153,102,51);
        ccColor3B white = ccc3(255,255,255);
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Title.mp3"];
        AWHSynchLabel *synchLabel=[[AWHSynchLabel alloc] initWithLabel:@"Rocky Don't Eat That!" fontName:@"Hobo.ttf" fontSize:[scaleManager scaleFontSize:54] withAnchor:[scaleManager scalePointX:5 andY:250] withBaseColor:rockyBrown withHighlightColor:white withIntervals:[NSArray arrayWithObjects:@"0.15",@"0.70",@"1.05",@"1.42", @"2.30",nil]];
        [self addChild:synchLabel];
        
        
        // Initialize sprite sheet
    /*    
        // Set the image format, defaulting to RGBA4444
        NSString *imageFormat = [levelDict objectForKey:@"ImageFormat"];
        if (imageFormat == nil || imageFormat == @"RGBA4444") {
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        } else if (imageFormat == @"RGBA8888") {
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        } 
        
        // Load the sheets
        NSString *spriteSheet = [levelDict objectForKey:@"SpriteSheet"];
        CCSpriteBatchNode *spritesBNode;
        spritesBNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz", spriteSheet]];
        [self addChild:spritesBNode];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist", spriteSheet]];
        
        // Set up sprites
        for (NSDictionary* spriteDict in [levelDict objectForKey:@"Sprites"] ){
            AWHSprite *sprite=[[AWHSprite alloc] initWithDict:spriteDict];
            [self addChild:sprite];
        }
  */
        // Set up sprites
        [self initSpritesArray];
        
        // Load up the high score labels
        AWHHighScoreLabels *highScoreLabels = [[AWHHighScoreLabels alloc] initWithArray:[gameStateManager getHighScores]];
        [self addChild:highScoreLabels];

        
        // Play the sound
        [[SimpleAudioEngine sharedEngine] playEffect:@"Title.mp3"];

        
	}
	return self;
}

/*- (void)draw {
    // ...
    
    // draw a simple line
    // The default state is:
    // Line Width: 1
    // color: 255,255,255,255 (white, non-transparent)
    // Anti-Aliased
    glEnable(GL_LINE_SMOOTH);
    ccDrawLine( ccp(307.5-(67.5/2), 230), ccp(307.5+(67.5/2), 230) );
    
    // ...
}*/

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	self.adWhirlView.delegate = nil;
    self.adWhirlView = nil;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void)adWhirlWillPresentFullScreenModal {
    
    
}

- (void)adWhirlDidDismissFullScreenModal {
    
    
}

- (NSString *)adWhirlApplicationKey {
    return @"ed84628313c54d739a528136cf4c6914";
}

- (UIViewController *)viewControllerForPresentingModalView {
    return viewController;    
}

-(void)adjustAdSize {
	//1
	[UIView beginAnimations:@"AdResize" context:nil];
	[UIView setAnimationDuration:0.2];
	//2
	CGSize adSize = [adWhirlView actualAdSize];
	//3
	CGRect newFrame = adWhirlView.frame;
	//4
	newFrame.size.height = adSize.height;
	
   	//5 
    CGSize winSize = [CCDirector sharedDirector].winSize;
    //6
	newFrame.size.width = winSize.width;
	//7
//    AWHScaleManager *scaleManager = [AWHScaleManager sharedScaleManager];
	//newFrame.origin.x = (self.adWhirlView.bounds.size.width - adSize.width)/2;
    newFrame.origin.x = (self.adWhirlView.bounds.size.width - adSize.width-[scaleManager scaleAdPadding]);
    
    //8 
    
	newFrame.origin.y = (winSize.height - adSize.height-[scaleManager scaleAdOriginY]-[scaleManager scaleAdPadding]);
	//9
    //NSLog(@"adjustAdSize Ad x: %f y: %f  Win x: %f y: %f ", adSize.width, adSize.height, winSize.width, winSize.height);
	adWhirlView.frame = newFrame;
	//10
	[UIView commitAnimations];
}

- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlVieww {
    //1
    [adWhirlView rotateToOrientation:UIInterfaceOrientationLandscapeRight];
	//2    
    [self adjustAdSize];
    
}

-(void)onEnter {
    //1
    viewController = [(AppDelegate *)[[UIApplication sharedApplication] delegate] viewController];
    //2
    self.adWhirlView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
    //3
    self.adWhirlView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    //4
    [adWhirlView updateAdWhirlConfig];
    //5
	CGSize adSize = [adWhirlView actualAdSize];
    //6
    CGSize winSize = [CCDirector sharedDirector].winSize;
    //NSLog(@"Ad x: %f y: %f  Win x: %f y: %f ", adSize.width, adSize.height, winSize.width, winSize.height);
    //7
    // Original code commented out to center the ad
	//self.adWhirlView.frame = CGRectMake((winSize.width/2)-(adSize.width/2),winSize.height-adSize.height,winSize.width,adSize.height);
 //   AWHScaleManager *scaleManager = [AWHScaleManager sharedScaleManager];
    self.adWhirlView.frame = CGRectMake((winSize.width)-(adSize.width)-[scaleManager scaleAdPadding],winSize.height-adSize.height-[scaleManager scaleAdOriginY]-[scaleManager scaleAdPadding],winSize.width,adSize.height);
    
    
    //8
	self.adWhirlView.clipsToBounds = YES;
    //9
    [viewController.view addSubview:adWhirlView];
    //10
    [viewController.view bringSubviewToFront:adWhirlView];
    //11
    [super onEnter];
}

-(void)onExit {
    //1
    if (adWhirlView) {
        [adWhirlView removeFromSuperview];
        [adWhirlView replaceBannerViewWith:nil];
        [adWhirlView ignoreNewAdRequests];
        [adWhirlView setDelegate:nil];
        self.adWhirlView = nil;
    }
	[super onExit];
}



@end
