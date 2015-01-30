//
//  FlyingNumber.h
//  Deditio
//
//  Created by Mark on 1/25/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Spinner.h"

@interface FlyingNumber : CCNode

// number properties
@property (assign, nonatomic) int numberValue;
@property (strong, nonatomic) CCLabelTTF *numberLabel;

// spawning
- (void)updateNumber:(FlyingNumber *)number basedOn:(Spinner *)spinner
         andGetValue:(int)getValue andNumberOfGets:(int)numberOfGets andPosition:(CGSize)screenSize;

@end
