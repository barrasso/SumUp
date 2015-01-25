//
//  GameState.h
//  Deditio
//
//  Created by Mark on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

@property (assign, nonatomic) BOOL *isNewGame;

@property (assign, nonatomic) int currentSumValue;
@property (assign, nonatomic) int currentGetValue;



@end
