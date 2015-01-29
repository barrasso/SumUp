//
//  Spinner.m
//  Deditio
//
//  Created by Mark on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Spinner.h"

@implementation Spinner

- (id)init
{
    self = [super init];
    
    self.topValue = arc4random() % 1 + 2;
    self.leftValue = 0;
    self.bottomValue = arc4random () % 3 + 3;
    self.rightValue = -1;
    
    return self;
}

- (void)updateSpinnerValues:(Spinner *)spinner andCurrentGet:(int)getValue andNumberOfGets:(int)numberOfGets
{
    // based on get value and number of gets, update new spinner values
    
}

- (void)fadeInGameScene
{
    CCScene *gameScene = (CCScene *)[CCBReader loadAsScene:@"GameScene"];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:1];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:transition];
}

@end
