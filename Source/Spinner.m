//
//  Spinner.m
//  Deditio
//
//  Created by Mark on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Spinner.h"

@implementation Spinner

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    self.topValue = arc4random() % 2 + 2;
    self.leftValue = arc4random() % 3 + 3;
    self.bottomValue = arc4random () % 4 + 4;
    self.rightValue = arc4random() % 1 - 3;
    
    return self;
}

#pragma mark - Scaling Methods

- (Spinner *)updateSpinnerValues:(Spinner *)spinner withGetValue:(int)getValue
{
    int range = 5;
    int multiplier = 5;
    
    // change range and mulitplier based on get value
    
    
    // update new spinner values
    spinner.topValue = (arc4random() % range + 2) * multiplier;
    spinner.leftValue = (arc4random() % range + 2) * multiplier;
    spinner.bottomValue = (arc4random() % range + 2) * multiplier;
    spinner.rightValue = (arc4random() % range - 2) * multiplier;
    
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
