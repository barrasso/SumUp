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
}

- (void)onExit
{
    // deallocate
    [super onExit];
}

#pragma mark - Tutorial Action Methods

- (void)performActionForState:(TutorialState)state
{
    // base next action on state
    switch (state) {
        case StateZero:
            
            CCLOG(@"State: %ld",self.currentState);
            
            break;
            
        case StateOne:
            //
            CCLOG(@"State: %ld",self.currentState);
            
            // show and hide labels
            self.label1.visible = NO;
            self.label2.visible = NO;
            self.label3.visible = NO;
            self.label4.visible = YES;
            
            break;
            
        case StateTwo:
            //
            CCLOG(@"State: %ld",self.currentState);
            
            self.label4.visible = NO;
            self.label5.visible = YES;

            break;
            
        case StateThree:
            //
            CCLOG(@"State: %ld",self.currentState);
            
            // finish tutorial
            self.label5.visible = NO;
            self.label6.visible = YES;
            break;
            
        default:
            break;
    }
}

@end
