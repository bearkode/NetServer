/*
 *  BKHand+LeapAddtions.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKHand+LeapAddtions.h"
#import "BKVector+LeapAdditions.h"


NSUInteger BKGetExtendedFingerCount(LeapHand *aHand)
{
    NSUInteger sResult  = 0;
    NSArray   *sFingers = [aHand fingers];
    
    for (LeapFinger *sFinger in sFingers)
    {
        if ([sFinger isExtended])
        {
            sResult++;
        }
    }
    
    return sResult;
}


@implementation BKHand (LeapAddtions)


+ (instancetype)handWithLeapHand:(LeapHand *)aLeapHand
{
    return [[[self alloc] initWithLeapHand:aLeapHand] autorelease];
}


- (instancetype)initWithLeapHand:(LeapHand *)aLeapHand
{
    self = [super init];
    
    if (self)
    {
        if (aLeapHand)
        {
            mEnabled             = YES;
            mTimeInterval        = [[NSDate date] timeIntervalSince1970];
            mExtendedFingerCount = BKGetExtendedFingerCount(aLeapHand);
            mPalmPosition        = [[BKVector vectorWithLeapVector:[aLeapHand palmPosition]] retain];
            mPalmNormal          = [[BKVector vectorWithLeapVector:[aLeapHand palmNormal]] retain];
        }
        else
        {
            mEnabled = NO;
        }
    }
    
    return self;
}


@end
