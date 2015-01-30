//
//  GameScene.h
//  Deditio
//
//  Created by Mark on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface GameScene : CCNode

// position of the spinner
typedef NS_ENUM(NSInteger, SpinnerPosition)
{
    SpinnerPositionZero = 0,
    SpinnerPositionOne = 1,
    SpinnerPositionTwo = 2,
    SpinnerPositionThree = 3
};

// labels
@property (strong, nonatomic) CCLabelTTF *topLabel;
@property (strong, nonatomic) CCLabelTTF *rightLabel;
@property (strong, nonatomic) CCLabelTTF *bottomLabel;
@property (strong, nonatomic) CCLabelTTF *leftLabel;
@property (strong, nonatomic) CCLabelTTF *scoreLabel;
@property (strong, nonatomic) CCLabelTTF *getSumLabel;

@end
