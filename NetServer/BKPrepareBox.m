/*
 *  BKPrepareBox.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKPrepareBox.h"


static CGFloat const kMinX = -70;
static CGFloat const kMaxX = 70;
static CGFloat const kMinY = 100;
static CGFloat const kMaxY = 200;
static CGFloat const kMinZ = -70;
static CGFloat const kMaxZ = 70;


@implementation BKPrepareBox


+ (BOOL)containsPosition:(BKVector *)aVector
{
    if ([aVector x] >= kMinX && [aVector x] <= kMaxX &&
        [aVector y] >= kMinY && [aVector y] <= kMaxY &&
        [aVector z] >= kMinZ && [aVector z] <= kMaxZ)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
