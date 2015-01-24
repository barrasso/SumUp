//
// DEDITIO
// MainScene.h
//
// Created by Mark 1/24/15.
//
// Copyright Mark Barrasso 2015.
//

#import "MainScene.h"
#import "Spinner.h"

@implementation MainScene
{
    // spinner container
    CCNode *_spinnerContainer;
    
    // spinner
    Spinner *_spinner;
    
    // location in node
    CGPoint touchLocation;
}

#pragma mark - View Initialization

- (void)didLoadFromCCB
{
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;    
}

- (void)onExit
{
    // deallocate
    [super onExit];
}

#pragma mark - Touch Handling

- (void)touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event
{
    // get touch location
    touchLocation = [touch locationInNode:self];
    
    // check if spinner container was touched
    if (CGRectContainsPoint(_spinnerContainer.boundingBox, touchLocation)) {
        [[_spinner animationManager] runAnimationsForSequenceNamed:@"Spin"];
        self.userInteractionEnabled = NO;
        self.multipleTouchEnabled = NO;
    }
}

@end
