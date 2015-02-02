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
    CCNode *_centerNode;
    
    // numbers
    FlyingNumber *_flyingNumber;
    CCPhysicsNode *_physicsNode;
    NSMutableArray *_allFlyingNumbers;

    // Screen Size
    CGSize _screenSize;
    
    // game values
    int _currentSumValue;
    int _currentGetValue;
    int _numberOfGets;
    
    // flags
    BOOL _isGameOver;
}

#pragma mark - Lifecycle

- (void)didLoadFromCCB
{
    // disable interaction and multi touch
    self.userInteractionEnabled = NO;
    self.multipleTouchEnabled = NO;
    
    // Get device screen size
    _screenSize = [[CCDirector sharedDirector] viewSize];
    self.contentSizeType = CCSizeTypeNormalized;
    
    // init flying numbers array
    _allFlyingNumbers = [[NSMutableArray alloc] init];
    
    // start new game
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
    if (!_isGameOver) {
        
        for (FlyingNumber *number in _allFlyingNumbers)
        {
            // check if number hit center
            if (CGRectContainsPoint(_centerNode.boundingBox, number.position))
            {
                [self numberDidReachCenter:number];
            
                // check game state
                [self checkGameScore:_currentSumValue];
            }
        }
    }
}

#pragma mark - Touch Handling Methods

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    switch (_position)
    {
        case SpinnerPositionZero:
            // rotate spinner and change position
            [[self animationManager] runAnimationsForSequenceNamed:@"Rotate90"];
            _position = SpinnerPositionOne;
            
            // shift numbers and update labels
            [self shiftSpinnerValues];
            [self updateSpinnerLabels];
            
            break;
        case SpinnerPositionOne:
            // rotate spinner and change position
            [[self animationManager] runAnimationsForSequenceNamed:@"Rotate180"];
            _position = SpinnerPositionTwo;
            
            // shift numbers and update labels
            [self shiftSpinnerValues];
            [self updateSpinnerLabels];
            
            break;
        case SpinnerPositionTwo:
            // rotate spinner and change position
            [[self animationManager] runAnimationsForSequenceNamed:@"Rotate270"];
            _position = SpinnerPositionThree;
            
            // shift numbers and update labels
            [self shiftSpinnerValues];
            [self updateSpinnerLabels];
            
            break;
        case SpinnerPositionThree:
            // rotate spinner and change position
            [[self animationManager] runAnimationsForSequenceNamed:@"Rotate360"];
            _position = SpinnerPositionZero;
            
            // shift numbers and update labels
            [self shiftSpinnerValues];
            [self updateSpinnerLabels];
            
            break;
        default:
            break;
    }
}

#pragma mark - Game Utility Methods

- (void)startNewGame
{
    // reset values
    _isGameOver = NO;
    _numberOfGets = 0;
    _currentSumValue = 0;
    _currentGetValue = ((arc4random() % 13) + 6);
    _position = SpinnerPositionZero;

    // spawn initial number
    [self spawnInitialNumber];
    
    // set labels
    self.scoreLabel.string = [NSString stringWithFormat:@"%i",_numberOfGets];
    self.getSumLabel.string = [NSString stringWithFormat:@"%i",_currentGetValue];
    [self updateSpinnerLabels];
}

- (void)spawnInitialNumber
{
    
    // update the spinner values and labels
    [_spinner updateSpinnerValues:_spinner withNumberOfGets:_numberOfGets];
    [self updateSpinnerLabels];
    
    // spawn new flying number with updated value
    _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
    [_flyingNumber updateNumber:_flyingNumber withNewValue:[_spinner calculateNewNumberValue:_spinner withCurrentGetValue:_currentGetValue]];
    
    // determine position and add to game
    _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
    [_allFlyingNumbers addObject:_flyingNumber];
    [_physicsNode addChild:_flyingNumber];
//    // init flying number
//    _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
//    _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
//    _flyingNumber.numberValue = arc4random() % 2 + 2;
//    _flyingNumber.numberLabel.string = [NSString stringWithFormat:@"%i",_flyingNumber.numberValue];
//    [_flyingNumber.physicsBody applyForce:ccp(0.0f, -12000.f)];
//    
//    // add object to physics node and array
//    [_allFlyingNumbers addObject:_flyingNumber];
//    [_physicsNode addChild:_flyingNumber];
}

- (void)enableInteraction
{
    // enable interaction and multi touch
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
}

- (void)shiftSpinnerValues
{
    int tempTop = _spinner.topValue;
    int tempRight = _spinner.rightValue;
    int tempBottom = _spinner.bottomValue;
    int tempLeft = _spinner.leftValue;
    _spinner.topValue = tempLeft;
    _spinner.rightValue = tempTop;
    _spinner.bottomValue = tempRight;
    _spinner.leftValue = tempBottom;
}

- (void)updateSpinnerLabels
{
    if (_spinner.topValue > 0) {
        self.topLabel.string = [NSString stringWithFormat:@"+%i",_spinner.topValue];
    } else {
        self.topLabel.string = [NSString stringWithFormat:@"%i",_spinner.topValue];
    }
    
    if (_spinner.rightValue > 0) {
        self.rightLabel.string = [NSString stringWithFormat:@"+%i",_spinner.rightValue];
    } else {
        self.rightLabel.string = [NSString stringWithFormat:@"%i",_spinner.rightValue];
    }
    
    if (_spinner.bottomValue > 0) {
        self.bottomLabel.string = [NSString stringWithFormat:@"+%i",_spinner.bottomValue];
    } else {
        self.bottomLabel.string = [NSString stringWithFormat:@"%i",_spinner.bottomValue];
    }
    
    if (_spinner.leftValue > 0) {
        self.leftLabel.string = [NSString stringWithFormat:@"+%i",_spinner.leftValue];
    } else {
        self.leftLabel.string = [NSString stringWithFormat:@"%i",_spinner.leftValue];
    }
}

#pragma mark - Game State Methods

- (void)checkGameScore:(int)currentSum
{
    if (currentSum > _currentGetValue)
    {
        CCLOG(@"YOU LOSE");
        
        // game over
        _isGameOver = YES;
    }
    else if (currentSum == _currentGetValue)
    {
        CCLOG(@"NEXT!");
        
        // calculate new get value and update label
        _currentGetValue = (_currentGetValue + ((arc4random() % _currentGetValue) + (_currentGetValue * 2)));
        self.getSumLabel.string = [NSString stringWithFormat:@"%i",_currentGetValue];
        
        // increment number of gets
        _numberOfGets++;
        
        // update the spinner values and labels
        [_spinner updateSpinnerValues:_spinner withNumberOfGets:_numberOfGets];
        [self updateSpinnerLabels];
        
        // spawn new flying number with updated value
        _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
        [_flyingNumber updateNumber:_flyingNumber withNewValue:[_spinner calculateNewNumberValue:_spinner withCurrentGetValue:_currentGetValue]];
        
        // determine position and add to game
        _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
        [_allFlyingNumbers addObject:_flyingNumber];
        [_physicsNode addChild:_flyingNumber];
        
        // reset sum
        _currentSumValue = 0;
    }
}

- (void)numberDidReachCenter:(FlyingNumber *)number
{
    // do particle effect on number position??????
    
    
    // deal with number (so update doesn't call again)
    number.visible = NO;
    number.position = CGPointMake(_screenSize.width * 1.5, _screenSize.height * 1.5);
    
    // run single pulse spinner animation
    [_spinner.animationManager runAnimationsForSequenceNamed:@"SinglePulse"];
    
    // figure out user sum
    _currentSumValue = number.numberValue + _spinner.topValue;
    
    // update score label
    self.scoreLabel.string = [NSString stringWithFormat:@"%i",_numberOfGets];
    
    // play +1 score animation????????
    
    
    // must number remove from scene
    [_allFlyingNumbers removeObject:number];
    [number removeFromParent];
}

- (void)retry
{
    CCScene *gameScene = (CCScene *)[CCBReader loadAsScene:@"GameScene"];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:1];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:transition];
}

@end
