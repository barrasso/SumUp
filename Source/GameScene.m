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
    SpinnerPosition position;
    
    // sum values
    int currentSumValue;
    int currentGetValue;
    
    // game values
    int timeAlive;
    int numberOfComputations;
    
    // flags
    BOOL isGameOver;
}

#pragma mark - Initialization

- (void)didLoadFromCCB
{
    // enable interaction and multi touch
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    
    // load game
    [self startNewGame];
    
    
}

- (void)onExit
{
    // deallocate
    [super onExit];
}

- (void)startNewGame
{
    // reset values
    isGameOver = NO;
    timeAlive = 0;
    numberOfComputations = 0;
    currentSumValue = 0;
    currentGetValue = ((arc4random() % 13) + 6);
    position = SpinnerPositionOne;
    
    // set labels
    self.sumLabel.string = [NSString stringWithFormat:@"%i",currentSumValue];
    self.getSumLabel.string = [NSString stringWithFormat:@"%i",currentGetValue];
    self.topLabel.string = [NSString stringWithFormat:@"+%i",_spinner.topValue];
    self.leftLabel.string = [NSString stringWithFormat:@"+%i",_spinner.leftValue];
    self.bottomLabel.string = [NSString stringWithFormat:@"+%i",_spinner.bottomValue];
    self.rightLabel.string = [NSString stringWithFormat:@"%i",_spinner.rightValue];


}

@end
