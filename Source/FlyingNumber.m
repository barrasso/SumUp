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

- (void)updateNumber:(FlyingNumber *)number withNewValue:(int)value
{
    // update flying number value
    self.numberValue = value;
    [self.physicsBody applyForce:ccp(0.0f, -10000.f)];
    self.numberLabel.string = [NSString stringWithFormat:@"%i",self.numberValue];
}

@end
