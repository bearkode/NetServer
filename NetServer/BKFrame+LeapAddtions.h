/*
 *  BKFrame+LeapAddtions.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKFrame.h"
#import "LeapObjectiveC.h"


@interface BKFrame (LeapAddtions)


+ (instancetype)frameWithLeapHand:(LeapHand *)aLeapHand;

- (instancetype)initWithLeapHand:(LeapHand *)aLeapHand;


@end
