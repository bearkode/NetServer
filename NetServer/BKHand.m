/*
 *  BKHand.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 10..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKHand.h"


@implementation BKHand


@synthesize timeInterval       = mTimeInterval;
@synthesize enabled            = mEnabled;
@synthesize extenedFingerCount = mExtendedFingerCount;
@synthesize palmPosition       = mPalmPosition;
@synthesize palmNormal         = mPalmNormal;


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        mTimeInterval = [[NSDate date] timeIntervalSince1970];
    }
    
    return self;
}


- (void)dealloc
{
    [mPalmPosition release];
    [mPalmNormal release];
    
    [super dealloc];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%d, pos = [%f, %f, %f] nor = [%f, %f, %f]", (int)mExtendedFingerCount, [mPalmPosition x], [mPalmPosition y], [mPalmPosition z], [mPalmNormal x], [mPalmNormal y], [mPalmNormal z]];
}


- (BOOL)isEqualToHand:(BKHand *)aHand
{
    if (mTimeInterval == [aHand timeInterval] &&
        mExtendedFingerCount == [aHand extenedFingerCount] &&
        [mPalmPosition isEqualToVector:[aHand palmPosition]] &&
        [mPalmNormal isEqualToVector:[aHand palmNormal]])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (NSDictionary *)JSONObject
{
    if (mEnabled)
    {
        return @{ @"class" : @"hand",
                  @"ti" : [NSNumber numberWithDouble:mTimeInterval],
                  @"enabled" : @YES,
                  @"extendedFingerCount" : [NSNumber numberWithInteger:mExtendedFingerCount],
                  @"palmPosition" : [mPalmPosition JSONObject],
                  @"palmNormal" : [mPalmNormal JSONObject] };
    }
    else
    {
        return @{ @"class" : @"hand",
                  @"ti" : [NSNumber numberWithDouble:mTimeInterval],
                  @"enabled" : @NO };
    }
}


@end
