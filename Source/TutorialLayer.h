//
//  TutorialLayer.h
//  Deditio
//
//  Created by Mark on 2/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface TutorialLayer : CCNode

// state of the layer
typedef NS_ENUM(NSInteger, TutorialState)
{
    StateZero = 0,
    StateOne = 1,
    StateTwo = 2,
    StateThree = 3
};

// state
@property (assign, nonatomic) TutorialState currentState;

// labels
@property (strong, nonatomic) CCLabelTTF *label1;
@property (strong, nonatomic) CCLabelTTF *label2;
@property (strong, nonatomic) CCLabelTTF *label3;
@property (strong, nonatomic) CCLabelTTF *label4;
@property (strong, nonatomic) CCLabelTTF *label5;
@property (strong, nonatomic) CCLabelTTF *label6;

// tutorial state
- (void)performActionForState:(TutorialState)state;

@end
