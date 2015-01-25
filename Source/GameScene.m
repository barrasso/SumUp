//
//  GameScene.m
//  Deditio
//
//  Created by Mark on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "Spinner.h"

@implementation GameScene
{
    // spinner container
    CCNode *_spinnerContainer;
    
    // spinner
    Spinner *_spinner;
    
    // labels
    CCLabelTTF *_centerLabel;
    CCLabelTTF *_topLabel;
    CCLabelTTF *_rightLabel;
    CCLabelTTF *_bottomLabel;
    CCLabelTTF *_leftLabel;
    
    CCLabelTTF *_sumLabel;
    CCLabelTTF *_getSumLabel;
}

#pragma mark - View Initialization

- (void)didLoadFromCCB
{
    // enable interaction and multi touch
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    
    // load initial game setup
    
}

- (void)onExit
{
    // deallocate
    [super onExit];
}

@end
