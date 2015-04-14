/*
 *  BKVector+LeapAdditions.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKVector.h"
#import "LeapObjectiveC.h"


@interface BKVector (LeapAdditions)


+ (instancetype)vectorWithLeapVector:(LeapVector *)aLeapVector;


@end
