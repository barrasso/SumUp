//
//  FlyingNumber.m
//  Deditio
//
//  Created by Mark on 1/25/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "FlyingNumber.h"
#import "Spinner.h"

@implementation FlyingNumber

#pragma mark - Spawning Methods

- (void)updateNumber:(FlyingNumber *)number basedOn:(Spinner *)spinner andGetValue:(int)getValue andNumberOfGets:(int)numberOfGets andPosition:(CGSize)screenSize
{
    // based on get value and spinner values, update flying number value
    
    
    self.position = CGPointMake(screenSize.width * 0.5, screenSize.height * 1.2);
    self.numberValue = arc4random() % 2 + 2;
    [self.physicsBody applyForce:ccp(0.0f, -12000.f)];
    self.numberLabel.string = [NSString stringWithFormat:@"%i",self.numberValue];
}

@end
