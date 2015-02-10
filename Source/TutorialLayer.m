//
//  TutorialLayer.m
//  Deditio
//
//  Created by Mark on 2/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TutorialLayer.h"

@implementation TutorialLayer

#pragma mark - Lifecycle

- (void)onEnter
{
    [super onEnter];
    
    // init tutorial state
    self.currentState = StateZero;
    
    // disable buttons
    self.retryTutorialButton.visible = NO;
    self.retryTutorialButton.userInteractionEnabled = NO;
    self.gotItButton.visible = NO;
    self.gotItButton.userInteractionEnabled = NO;
}

- (void)onExit
{
    // deallocate
    [super onExit];
}

#pragma mark - Selectors

- (void)resumeGameplay
{
    // set tutorial mode to seen
    
    // remove layer
    CCScene *gameScene = (CCScene *)[CCBReader loadAsScene:@"GameScene"];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:1];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:transition];
}

- (void)retryTutorial
{
    CCScene *gameScene = (CCScene *)[CCBReader loadAsScene:@"GameScene"];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:1];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:transition];
}

#pragma mark - Tutorial State Methods

- (void)performActionForState:(TutorialState)state
{
    // base next action on state
    switch (state) {
        case StateZero:
            CCLOG(@"State: %ld",self.currentState);
            break;
            
        case StateOne:
            [[self animationManager] runAnimationsForSequenceNamed:@"StateOne"];
            break;
            
        case StateTwo:
            [[self animationManager] runAnimationsForSequenceNamed:@"StateTwo"];
            break;
            
        case StateThree:
            [[self animationManager] runAnimationsForSequenceNamed:@"StateThree"];

            // enable buttons
            self.retryTutorialButton.visible = YES;
            self.retryTutorialButton.userInteractionEnabled = YES;
            self.gotItButton.visible = YES;
            self.gotItButton.userInteractionEnabled = YES;
            break;
            
        default:
            break;
    }
}

@end
