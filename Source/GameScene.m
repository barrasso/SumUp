//
//  GameScene.m
//  Deditio
//
//  Created by Mark on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "FlyingNumber.h"
#import "Spinner.h"

@implementation GameScene
{
    // spinner
    Spinner *_spinner;
    SpinnerPosition _position;
    CCNode *_spinnerContainer;
    CCNode *_centerNode;
    
    
    // numbers
    FlyingNumber *_flyingNumber;
    CCPhysicsNode *_physicsNode;
    NSMutableArray *_allFlyingNumbers;
    
    // Screen Size
    CGSize _screenSize;
    
    // sum values
    int _currentSumValue;
    int _currentGetValue;
    
    // game values
    int _timeAlive;
    int _numberOfComputations;
    
    // flags
    BOOL _isGameOver;
}

#pragma mark - Initialization

- (void)didLoadFromCCB
{
    // enable interaction and multi touch
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    
    // Get device screen size
    _screenSize = [[CCDirector sharedDirector] viewSize];
    self.contentSizeType = CCSizeTypeNormalized;
    
    // init flying numbers array
    _allFlyingNumbers = [[NSMutableArray alloc] init];
    
    // load game
    [self startNewGame];
}

- (void)onExit
{
    // deallocate
    [super onExit];
}

#pragma mark - Update Method

- (void)update:(CCTime)delta
{
    for (FlyingNumber *number in _allFlyingNumbers)
    {
        if (CGRectContainsPoint(_centerNode.boundingBox, number.position)) {
            NSLog(@"hit center");
        }
    }
}

#pragma mark - Game Utility Methods

- (void)startNewGame
{
    // reset values
    _isGameOver = NO;
    _timeAlive = 0;
    _numberOfComputations = 0;
    _currentSumValue = 0;
    _currentGetValue = ((arc4random() % 13) + 6);
    _position = SpinnerPositionZero;

    // spawn initial number
    [self spawnInitialNumber];
    
    // set labels
    self.sumLabel.string = [NSString stringWithFormat:@"%i",_currentSumValue];
    self.getSumLabel.string = [NSString stringWithFormat:@"%i",_currentGetValue];
    self.topLabel.string = [NSString stringWithFormat:@"+%i",_spinner.topValue];
    self.leftLabel.string = [NSString stringWithFormat:@"+%i",_spinner.leftValue];
    self.bottomLabel.string = [NSString stringWithFormat:@"+%i",_spinner.bottomValue];
    self.rightLabel.string = [NSString stringWithFormat:@"%i",_spinner.rightValue];
}

#pragma mark - Flying Number Methods

- (void)spawnInitialNumber
{
    // init flying number
    _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
    _flyingNumber.numberValue = arc4random() % 2 + 2;
    _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
    _flyingNumber.numberLabel.string = [NSString stringWithFormat:@"%i",_flyingNumber.numberValue];
    [_flyingNumber.physicsBody applyForce:ccp(0.0f, -8000.f)];
    
    // add object to physics node and array
    [_allFlyingNumbers addObject:_flyingNumber];
    [_physicsNode addChild:_flyingNumber];
}

@end
