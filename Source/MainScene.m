//
// DEDITIO
// MainScene.h
//
// Created by Mark 1/24/15.
//
// Copyright Mark Barrasso 2015.
//

#import "MainScene.h"
#import "GameScene.h"
#import "Spinner.h"

@implementation MainScene
{
    // spinner container
    CCNode *_spinnerContainer;
    
    // spinner
    Spinner *_spinner;
    
    // location in node
    CGPoint touchLocation;
    
    // labels
    CCLabelTTF *_playLabel;
}

#pragma mark - View Initialization

- (void)didLoadFromCCB
{
    self.userInteractionEnabled = NO;
    self.multipleTouchEnabled = NO;
}

- (void)onExit
{
    // deallocate
    [super onExit];
}

#pragma mark - Callbacks

- (void)enableInteraction
{
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
}

#pragma mark - Touch Handling

- (void)touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event
{
    // get touch location
    touchLocation = [touch locationInNode:self];
    
    // check if spinner container was touched
    if (CGRectContainsPoint(_spinnerContainer.boundingBox, touchLocation)) {
        [[self animationManager] runAnimationsForSequenceNamed:@"FadePlay"];
        [[_spinner animationManager] runAnimationsForSequenceNamed:@"SpinFast"];
        self.userInteractionEnabled = NO;
        self.multipleTouchEnabled = NO;
    }
}

@end
