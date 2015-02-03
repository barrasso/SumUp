//
//  Spinner.m
//  Deditio
//
//  Created by Mark on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
static const float scalingValue = 0.50f;

#import "Spinner.h"

@implementation Spinner

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    self.topValue = arc4random() % 2 + 2;
    self.leftValue = arc4random() % 2 + 3;
    self.bottomValue = arc4random () % 3 + 4;
    self.rightValue = arc4random() % 1 - 3;
    
    return self;
}

#pragma mark - Scaling Methods

- (Spinner *)updateSpinnerValues:(Spinner *)spinner withNumberOfGets:(int)numberOfGets
{
    if (numberOfGets !=0 ) {
    
        // update new spinner values
        spinner.topValue = spinner.topValue + spinner.topValue * scalingValue;
        spinner.leftValue = spinner.leftValue + spinner.leftValue * scalingValue;
        spinner.bottomValue = spinner.bottomValue + spinner.bottomValue * scalingValue;
        spinner.rightValue = spinner.rightValue + spinner.rightValue * scalingValue;
    }
    return spinner;
}

- (int)calculateNewNumberValue:(Spinner *)spinner withCurrentGetValue:(int)getValue
{
    int newValue = 0;
    int randomValue = arc4random() % 4;
    
    switch (randomValue) {
        case 0:
            newValue = getValue - spinner.topValue;
            break;
        case 1:
            newValue = getValue - spinner.leftValue;
            break;
        case 2:
            newValue = getValue - spinner.bottomValue;
            break;
        case 3:
            newValue = getValue - spinner.rightValue;
            break;
            
        default:
            break;
    }
    
    return newValue;
}

#pragma mark - Navigation Methods

- (void)fadeInGameScene
{
    CCScene *gameScene = (CCScene *)[CCBReader loadAsScene:@"GameScene"];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:1];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:transition];
}

@end
