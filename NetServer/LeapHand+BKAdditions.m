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


- (BKHand *)bkHand
{
    BKHand *sResult = [[[BKHand alloc] init] autorelease];

    [sResult setTimeInterval:[[NSDate date] timeIntervalSince1970]];
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

    return [[[BKVector alloc] initWithX:[sPalmPosition x] y:[sPalmPosition y] z:[sPalmPosition z]] autorelease];
}


- (BKVector *)bkPalmNormal
{
    LeapVector *sPalmNormal  = [self palmNormal];
    
    return [[[BKVector alloc] initWithX:[sPalmNormal x] y:[sPalmNormal y] z:[sPalmNormal z]] autorelease];
}


@end
