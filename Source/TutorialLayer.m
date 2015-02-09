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
    
    // show and hide labels
    self.label1.visible = YES;
    self.label2.visible = YES;
    self.label3.visible = YES;
    
    self.label4.visible = NO;
    self.label5.visible = NO;
    self.label6.visible = NO;
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
            CCLOG(@"State: %ld",self.currentState);
            
            // show and hide labels
            self.label1.visible = NO;
            self.label2.visible = NO;
            self.label3.visible = NO;
            self.label4.visible = YES;
            
            break;
            
        case StateTwo:
            CCLOG(@"State: %ld",self.currentState);
            
            // show and hide labels
            self.label4.visible = NO;
            self.label5.visible = YES;

            break;
            
        case StateThree:
            CCLOG(@"State: %ld",self.currentState);
            
            // finish tutorial
            self.label5.visible = NO;
            self.label6.visible = YES;
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
