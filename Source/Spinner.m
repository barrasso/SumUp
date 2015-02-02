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
    
    self.topValue = arc4random() % 1 + 2;
    self.leftValue = arc4random() % 1;
    self.bottomValue = arc4random () % 3 + 3;
    self.rightValue = -1;
    
    return self;
}

#pragma mark - Scaling Methods

- (void)updateSpinnerValues:(Spinner *)spinner withNumberOfGets:(int)numberOfGets
{
    // update new spinner values
    
    spinner.topValue = spinner.topValue * 2;
    spinner.leftValue = spinner.leftValue * 2;
    spinner.bottomValue = spinner.bottomValue * 2;
    spinner.rightValue = spinner.rightValue * 2;
    
//    switch (numberOfGets) {
//        case 0:
//            // do nothing
//            break;
//        case 1:
//            self.topValue = self.topValue * 2;
//            self.leftValue = self.leftValue * 2;
//            self.bottomValue = self.bottomValue * 2;
//            self.rightValue = self.rightValue * 2;
//
//            break;
//        default:
//            break;
//    }
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
