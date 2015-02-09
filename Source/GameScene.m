//
//  GameScene.m
//  Deditio
//
//  Created by Mark on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "TutorialLayer.h"
#import "FlyingNumber.h"
#import "Spinner.h"

@implementation GameScene
{
    // spinner
    Spinner *_spinner;
    CCNode *_centerNode;
    CCNode *_spinnerContainer;
    SpinnerPosition _position;
    
    // numbers
    FlyingNumber *_flyingNumber;
    CCPhysicsNode *_physicsNode;
    NSMutableArray *_allFlyingNumbers;

    // tutorial
    TutorialLayer *_tutorialLayer;
    
    // icons
    CCNode *_retryIcon;
    
    // Screen
    CGPoint _touchLocation;
    CGSize _screenSize;
    
    // game values
    int _currentSumValue;
    int _currentGetValue;
    int _currentScore;
    int _numberOfGets;
    
    // scalars
    int _range;
    int _multiplier;
    
    // flags
    BOOL _isGameOver;
    BOOL _didSwipeDown;
    BOOL _didTouchSpinner;
    BOOL _isTutorialModeActive;
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
    
    // add gesture recognizer
    UISwipeGestureRecognizer *swipeGesture =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [[CCDirector sharedDirector].view addGestureRecognizer: swipeGesture];
    
    // disable retry
    _retryIcon.visible = NO;
    _retryIcon.userInteractionEnabled = NO;
    
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
    // handle initial tutorial number
    if (!self.hasSeenTutorial) {
        
        if (_tutorialLayer.currentState == 0 || _tutorialLayer.currentState == 1) {
        
            for (FlyingNumber *number in _allFlyingNumbers)
            {
                if (number.position.y <= (_screenSize.height * 0.8)) {
                    // hold number in position
                    number.physicsBody.velocity = ccp(0,0);
                }
            }
        }
    }
    
    // handle numbers on gameplay
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
    _touchLocation = [touch locationInNode:self];
    
    /***** TUTORIAL STATE *****/
    if (!self.hasSeenTutorial) {
        
        if (_tutorialLayer.currentState == 0) {
            _tutorialLayer.currentState = 1;
            [_tutorialLayer performActionForState:_tutorialLayer.currentState];
            return;
        }
        
        if ((_tutorialLayer.currentState == 1) && (CGRectContainsPoint(_spinnerContainer.boundingBox, _touchLocation))) {
            
            // set flag
            _didTouchSpinner = YES;
            
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
                    
                    // now enable swipe down
                    _tutorialLayer.currentState = 2;
                    [_tutorialLayer performActionForState:_tutorialLayer.currentState];
                    
                    break;
                case SpinnerPositionTwo:
                    // DON'T SPIN AGAIN

                    
                    break;
                default:
                    break;
            }
        } else {
            _didTouchSpinner = NO;
        }
    }

    /***** NORMAL GAMEPLAY STATE *****/
    if (self.hasSeenTutorial && (CGRectContainsPoint(_spinnerContainer.boundingBox, _touchLocation))) {
        
        // check for game over
        if (_isGameOver) {
            [self retry];
        }
        
        // set flag
        _didTouchSpinner = YES;
        
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
    } else {
        _didTouchSpinner = NO;
    }
}

- (void)swipeDown
{
    if (!_didTouchSpinner && _tutorialLayer.currentState == 2) {
        // pull the number down hard
        [_flyingNumber.physicsBody applyForce:ccp(0.0f, -50000.f)];
        _didSwipeDown = YES;
    }
    
    if (!_didTouchSpinner) {
        // pull the number down hard
        [_flyingNumber.physicsBody applyForce:ccp(0.0f, -50000.f)];
        _didSwipeDown = YES;
    }
}

#pragma mark - Game Utility Methods

- (void)startNewGame
{
    // reset values
    _isGameOver = NO;
    _numberOfGets = 0;
    _currentScore = 0;
    _currentSumValue = 0;
    _currentGetValue = 10;
    _position = SpinnerPositionZero;

    // spawn initial number
    [self spawnInitialNumber];
    
    // set labels
    self.scoreLabel.string = [NSString stringWithFormat:@"%i",_currentScore];
    self.getSumLabel.string = [NSString stringWithFormat:@"%i",_currentGetValue];
    [self updateSpinnerLabels];
    
    // load tutorial statuses
    self.hasSeenTutorial = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HasSeenTutorial"] boolValue];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!self.hasSeenTutorial)
    {
        [self scheduleBlock:^(CCTimer *timer) {
            
            // load tutorial layer
            _tutorialLayer = (TutorialLayer *)[CCBReader load:@"TutorialLayer"];
            [self addChild:_tutorialLayer];
            [_tutorialLayer performActionForState:_tutorialLayer.currentState];
            
            // load tutorial values
            _spinner.bottomValue = 5;
            _flyingNumber.numberValue = 5;
            
        } delay:5.0];
    }
}

- (void)spawnInitialNumber
{
    // update the spinner values and labels
    _spinner = [_spinner updateSpinnerValues:_spinner withGetValue:_currentGetValue];
    [self updateSpinnerLabels];
    
    // spawn new flying number with updated value
    _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
    [_flyingNumber updateNumber:_flyingNumber withNewValue:[_spinner calculateNewNumberValue:_spinner withCurrentGetValue:_currentGetValue]];
    
    // determine position and add to game
    _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
    [_allFlyingNumbers addObject:_flyingNumber];
    [_physicsNode addChild:_flyingNumber];
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
    if (currentSum > _currentGetValue || currentSum < _currentGetValue)
    {
        CCLOG(@"YOU LOSE");
        
        // game over
        _isGameOver = YES;
        self.userInteractionEnabled = NO;
        
        // disable retry
        _retryIcon.visible = YES;
        _retryIcon.userInteractionEnabled = YES;
        
        [[self animationManager] runAnimationsForSequenceNamed:@"GameOver"];
        
        [self scheduleBlock:^(CCTimer *timer) {
            self.userInteractionEnabled = YES;
        } delay:1.5];
    }
    else if (currentSum == _currentGetValue)
    {
        CCLOG(@"NEXT!");
        
        // increment number of gets
        _numberOfGets++;
        
        if (_didSwipeDown) {
            _currentScore = _currentScore + ((_currentGetValue) + (_currentGetValue * 0.5));
            _didSwipeDown = NO;
        } else {
            _currentScore = _currentScore + (_currentGetValue);
        }
        
        // update score
        self.scoreLabel.string = [NSString stringWithFormat:@"%i",_currentScore];
        
        // set new range and multiplier based on number of gets
        [self updateRangeAndMultiplier:_numberOfGets];
        
        // calculate new get value and update label
        _currentGetValue = ((arc4random() % _range + 1) * _multiplier);
        self.getSumLabel.string = [NSString stringWithFormat:@"%i",_currentGetValue];
        
        // update the spinner values and labels
        _spinner = [_spinner updateSpinnerValues:_spinner withGetValue:_currentGetValue];
        [self updateSpinnerLabels];
        
        
        // if in tutorial
        if (_tutorialLayer.currentState == 2) {
            _tutorialLayer.currentState = 3;
            [_tutorialLayer performActionForState:_tutorialLayer.currentState];
        } else {
            
            // spawn new flying number with updated value
            _flyingNumber = (FlyingNumber *)[CCBReader load:@"FlyingNumber"];
            [_flyingNumber updateNumber:_flyingNumber withNewValue:[_spinner calculateNewNumberValue:_spinner withCurrentGetValue:_currentGetValue]];
            
            // determine position and add to game
            _flyingNumber.position = CGPointMake(_screenSize.width * 0.5, _screenSize.height * 1.2);
            [_allFlyingNumbers addObject:_flyingNumber];
            [_physicsNode addChild:_flyingNumber];
        }
        
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
    
    // must number remove from scene
    [_allFlyingNumbers removeObject:number];
    [number removeFromParent];
}

- (void)updateRangeAndMultiplier:(int)gets
{
    switch (gets) {
        case 0:
            // do nothing
            break;
        case 1:
            _range = 10;
            _multiplier = 5;
            break;
            
        default:
            break;
    }
}

- (void)retry
{
    CCScene *gameScene = (CCScene *)[CCBReader loadAsScene:@"GameScene"];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:1];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:transition];
}

@end
