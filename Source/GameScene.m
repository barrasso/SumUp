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
    
    // temp number value
    int tempValue;
    
    // Screen Size
    CGSize _screenSize;
    
    // sum values
    int _currentSumValue;
    int _currentGetValue;
    int numberofGets;
    
    // game values
    int _timeAlive;
    int _numberOfComputations;
    
    // flags
    BOOL _isGameOver;
}

#pragma mark - Initialization

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
    // if its not over
    if (!_isGameOver) {
        
        for (FlyingNumber *number in _allFlyingNumbers)
        {
            // check if number hit center
            if (CGRectContainsPoint(_centerNode.boundingBox, number.position))
            {
                // do particle effect on number position??????
                tempValue = number.numberValue;

                // deal with number
                number.visible = NO;
                number.position = CGPointMake(_screenSize.width * 1.5, _screenSize.height * 1.5);
                
                // run single pulse spinner animation
                [_spinner.animationManager runAnimationsForSequenceNamed:@"SinglePulse"];
                
                // update sum label
                if (_spinner.topValue != 0) {
                    _currentSumValue = _currentSumValue + number.numberValue + _spinner.topValue;
                    _sumLabel.string = [NSString stringWithFormat:@"%i",_currentSumValue];
                } else {
                    // play 0 animation?
                }
                
                // must remove from numaers array
                [_allFlyingNumbers removeObject:number];
                
                // remove number
                [number removeFromParent];
                
                // check for 'loss' or 'next get' condition
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
        
        // increase get value and update label
        _currentGetValue = (_currentGetValue + ((arc4random() % _currentGetValue) + (_currentGetValue * 2)));
        _getSumLabel.string = [NSString stringWithFormat:@"%i",_currentGetValue];
        
        // increment get
        _numberOfComputations++;
        
        // chceck number of gets
        switch (_numberOfComputations) {
            case 1:
                // increase spinner values and update labels
                _spinner.topValue = _spinner.topValue +  (_spinner.topValue * 2);
                _spinner.bottomValue = _spinner.bottomValue + (_spinner.bottomValue * 2);
                _topLabel.string = [NSString stringWithFormat:@"%i",_spinner.topValue];
                _bottomLabel.string = [NSString stringWithFormat:@"%i",_spinner.bottomValue];
                
                // spawn new flying number
                // init flying number
                _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
                _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
                
                // increase flying number values, speed and update labels
                _flyingNumber.numberValue = arc4random() % 4 + 4;
                _flyingNumber.numberLabel.string = [NSString stringWithFormat:@"%i",_flyingNumber.numberValue];
                [_flyingNumber.physicsBody applyForce:ccp(0.0f, -12500.f)];
                
                // add object to physics node and array
                [_allFlyingNumbers addObject:_flyingNumber];
                [_physicsNode addChild:_flyingNumber];
                
                break;
            case 2:
                // increase spinner values and update labels
                _spinner.topValue = _spinner.topValue +  (_spinner.topValue * 2);
                _spinner.bottomValue = _spinner.bottomValue + (_spinner.bottomValue * 2);
                _topLabel.string = [NSString stringWithFormat:@"%i",_spinner.topValue];
                _bottomLabel.string = [NSString stringWithFormat:@"%i",_spinner.bottomValue];
                
                // spawn new flying number
                // init flying number
                _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
                _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
                
                // increase flying number values, speed and update labels
                _flyingNumber.numberValue = arc4random() % 8 + 8;
                _flyingNumber.numberLabel.string = [NSString stringWithFormat:@"%i",_flyingNumber.numberValue];
                [_flyingNumber.physicsBody applyForce:ccp(0.0f, -13000.f)];
                
                // add object to physics node and array
                [_allFlyingNumbers addObject:_flyingNumber];
                [_physicsNode addChild:_flyingNumber];
                break;
            case 3:
                // increase spinner values and update labels
                _spinner.topValue = _spinner.topValue +  (_spinner.topValue * 2);
                _spinner.bottomValue = _spinner.bottomValue + (_spinner.bottomValue * 2);
                _topLabel.string = [NSString stringWithFormat:@"%i",_spinner.topValue];
                _bottomLabel.string = [NSString stringWithFormat:@"%i",_spinner.bottomValue];
                
                // spawn new flying number
                // init flying number
                _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
                _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
                
                // increase flying number values, speed and update labels
                _flyingNumber.numberValue = arc4random() % 8 + 8;
                _flyingNumber.numberLabel.string = [NSString stringWithFormat:@"%i",_flyingNumber.numberValue];
                [_flyingNumber.physicsBody applyForce:ccp(0.0f, -13500.f)];
                
                // add object to physics node and array
                [_allFlyingNumbers addObject:_flyingNumber];
                [_physicsNode addChild:_flyingNumber];
                break;
            case 4:
                // increase spinner values and update labels
                _spinner.topValue = _spinner.topValue +  (_spinner.topValue * 2);
                _spinner.bottomValue = _spinner.bottomValue + (_spinner.bottomValue * 2);
                _topLabel.string = [NSString stringWithFormat:@"%i",_spinner.topValue];
                _bottomLabel.string = [NSString stringWithFormat:@"%i",_spinner.bottomValue];
                
                // spawn new flying number
                // init flying number
                _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
                _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
                
                // increase flying number values, speed and update labels
                _flyingNumber.numberValue = arc4random() % 16 + 16;
                _flyingNumber.numberLabel.string = [NSString stringWithFormat:@"%i",_flyingNumber.numberValue];
                [_flyingNumber.physicsBody applyForce:ccp(0.0f, -14000.f)];
                
                // add object to physics node and array
                [_allFlyingNumbers addObject:_flyingNumber];
                [_physicsNode addChild:_flyingNumber];
                break;
            case 5:
                // increase spinner values and update labels
                _spinner.topValue = _spinner.topValue +  (_spinner.topValue * 2);
                _spinner.bottomValue = _spinner.bottomValue + (_spinner.bottomValue * 2);
                _topLabel.string = [NSString stringWithFormat:@"%i",_spinner.topValue];
                _bottomLabel.string = [NSString stringWithFormat:@"%i",_spinner.bottomValue];
                
                // spawn new flying number
                // init flying number
                _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
                _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
                
                // increase flying number values, speed and update labels
                _flyingNumber.numberValue = arc4random() % 32 + 32;
                _flyingNumber.numberLabel.string = [NSString stringWithFormat:@"%i",_flyingNumber.numberValue];
                [_flyingNumber.physicsBody applyForce:ccp(0.0f, -14500.f)];
                
                // add object to physics node and array
                [_allFlyingNumbers addObject:_flyingNumber];
                [_physicsNode addChild:_flyingNumber];
                break;
            case 6:
                break;
            case 7:
                break;
            case 8:
                break;
            case 9:
                break;
            default:
                break;
        }
    }
    else if (currentSum < _currentGetValue) {
        
        // chceck number of gets
        switch (_numberOfComputations) {
            case 0:
                // init flying number
                _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
                _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
                _flyingNumber.numberValue = arc4random() % 2 + 2;
                _flyingNumber.numberLabel.string = [NSString stringWithFormat:@"%i",_flyingNumber.numberValue];
                [_flyingNumber.physicsBody applyForce:ccp(0.0f, -12000.f)];
                
                // add object to physics node and array
                [_allFlyingNumbers addObject:_flyingNumber];
                [_physicsNode addChild:_flyingNumber];
                break;
                
            case 1:
                // spawn new flying number
                // init flying number
                _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
                _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
                
                // increase flying number values, speed and update labels
                _flyingNumber.numberValue = arc4random() % 4 + 4;
                _flyingNumber.numberLabel.string = [NSString stringWithFormat:@"%i",_flyingNumber.numberValue];
                [_flyingNumber.physicsBody applyForce:ccp(0.0f, -12500.f)];
                
                // add object to physics node and array
                [_allFlyingNumbers addObject:_flyingNumber];
                [_physicsNode addChild:_flyingNumber];
                break;
            case 2:
                // init flying number
                _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
                _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
                _flyingNumber.numberValue = arc4random() % 8 + 8;
                _flyingNumber.numberLabel.string = [NSString stringWithFormat:@"%i",_flyingNumber.numberValue];
                [_flyingNumber.physicsBody applyForce:ccp(0.0f, -12000.f)];
                
                // add object to physics node and array
                [_allFlyingNumbers addObject:_flyingNumber];
                [_physicsNode addChild:_flyingNumber];
                break;
            case 3:
                // init flying number
                _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
                _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
                _flyingNumber.numberValue = arc4random() % 16 + 16;
                _flyingNumber.numberLabel.string = [NSString stringWithFormat:@"%i",_flyingNumber.numberValue];
                [_flyingNumber.physicsBody applyForce:ccp(0.0f, -12000.f)];
                
                // add object to physics node and array
                [_allFlyingNumbers addObject:_flyingNumber];
                [_physicsNode addChild:_flyingNumber];
                break;
            case 4:
                // init flying number
                _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
                _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
                _flyingNumber.numberValue = arc4random() % 32 + 32;
                _flyingNumber.numberLabel.string = [NSString stringWithFormat:@"%i",_flyingNumber.numberValue];
                [_flyingNumber.physicsBody applyForce:ccp(0.0f, -12000.f)];
                
                // add object to physics node and array
                [_allFlyingNumbers addObject:_flyingNumber];
                [_physicsNode addChild:_flyingNumber];
                break;
            default:
                break;
        }
        
    }

}

- (void)enableInteraction
{
    // disable interaction and multi touch
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

#pragma mark - Flying Number Methods

- (void)spawnInitialNumber
{
    // init flying number
    _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
    _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
    _flyingNumber.numberValue = arc4random() % 2 + 2;
    _flyingNumber.numberLabel.string = [NSString stringWithFormat:@"%i",_flyingNumber.numberValue];
    [_flyingNumber.physicsBody applyForce:ccp(0.0f, -12000.f)];
    
    // add object to physics node and array
    [_allFlyingNumbers addObject:_flyingNumber];
    [_physicsNode addChild:_flyingNumber];
}

@end
