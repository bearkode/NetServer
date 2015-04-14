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


+ (BOOL)containsPosition:(BKVector *)aPosition
{
    if ([self typeForPosition:aPosition] == BKPositionInBox)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (BKPositionType)typeForPosition:(BKVector *)aPosition
{
    BKPositionType sResult = BKPositionInBox;
    
    if ([aPosition x] < kMinX)
    {
        sResult = BKPositionLeftOfBox;
    }
    else if ([aPosition x] > kMaxX)
    {
        sResult = BKPositionRightOfBox;
    }
    else if ([aPosition y] < kMinY)
    {
        sResult = BKPositionUnderBox;
    }
    else if ([aPosition y] > kMaxY)
    {
        sResult = BKPositionOverBox;
    }
    else if ([aPosition z] < kMinZ)
    {
        sResult = BKPositionFrontOfBox;
    }
    else if ([aPosition z] > kMaxZ)
    {
        sResult = BKPositionBackOfBox;
    }
    
    return sResult;
}


@end
