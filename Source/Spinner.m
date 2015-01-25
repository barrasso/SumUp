//
//  Spinner.m
//  Deditio
//
//  Created by Mark on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Spinner.h"

@implementation Spinner
//
//- (id)init
//{
//
//    return self;
//}
//
//- (id)initWithValues:(NSDictionary *)data
//{
//    
//    return self;
//}
- (void)fadeInGameScene
{
    CCScene *gameScene = (CCScene *)[CCBReader loadAsScene:@"GameScene"];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:1];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:transition];
}

@end
