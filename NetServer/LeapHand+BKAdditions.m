/*
 *  LeapHand+BKAdditions.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 10..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "LeapHand+BKAdditions.h"


@implementation LeapHand (BKAdditions)


- (BKMotion *)motion
{
    BKMotion *sResult = [[[BKMotion alloc] init] autorelease];

    [sResult setExtenedFingerCount:[self bkExtendedFingerCount]];
    [sResult setPalmPosition:[self bkPalmPosition]];
    [sResult setPalmNormal:[self bkPalmNormal]];

    return sResult;
}


#pragma mark -


- (NSUInteger)bkExtendedFingerCount
{
    NSUInteger sResult  = 0;
    NSArray   *sFingers = [self fingers];
    
    for (LeapFinger *sFinger in sFingers)
    {
        if ([sFinger isExtended])
        {
            sResult++;
        }
    }
    
    return sResult;
}


- (BKVector *)bkPalmPosition
{
    LeapVector *sPalmPosition = [self palmPosition];

    return [[[BKVector alloc] initWithX:[sPalmPosition x] y:[sPalmPosition y] z:[sPalmPosition y]] autorelease];
}


- (BKVector *)bkPalmNormal
{
    LeapVector *sPalmNormal  = [self palmNormal];
    
    return [[[BKVector alloc] initWithX:[sPalmNormal x] y:[sPalmNormal y] z:[sPalmNormal z]] autorelease];
}


@end
