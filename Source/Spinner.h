//
//  Spinner.h
//  Deditio
//
//  Created by Mark on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Spinner : CCNode

@property (assign, nonatomic) int topValue;
@property (assign, nonatomic) int leftValue;
@property (assign, nonatomic) int bottomValue;
@property (assign, nonatomic) int rightValue;

- (Spinner *)updateSpinnerValues:(Spinner *)spinner withNumberOfGets:(int)numberOfGets;
- (int)calculateNewNumberValue:(Spinner *)spinner withCurrentGetValue:(int)getValue;

@end
