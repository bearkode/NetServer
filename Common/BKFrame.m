/*
 *  BKHand.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 10..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKFrame.h"


static NSString *const kClassKey               = @"frame";
static NSString *const kTimeintervalKey        = @"ti";
static NSString *const kEnabledKey             = @"enabled";
static NSString *const kExtendedFingerCountKey = @"extendedFingerCount";
static NSString *const kPalmPositionKey        = @"palmPosition";
static NSString *const kPalmNormalKey          = @"palmNormal";


@implementation BKFrame


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


- (instancetype)initWithJSONObject:(id)aJSONObject
{
    self = [self init];
    
    if (self)
    {
        mTimeInterval        = [[aJSONObject objectForKey:kTimeintervalKey] doubleValue];
        mEnabled             = [[aJSONObject objectForKey:kEnabledKey] boolValue];
        mExtendedFingerCount = [[aJSONObject objectForKey:kExtendedFingerCountKey] integerValue];
        mPalmPosition        = [[BKVector alloc] initWithJSONObject:[aJSONObject objectForKey:kPalmPositionKey]];
        mPalmNormal          = [[BKVector alloc] initWithJSONObject:[aJSONObject objectForKey:kPalmNormalKey]];
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


- (BOOL)isEqualToFrame:(BKFrame *)aFrame
{
    if (mTimeInterval == [aFrame timeInterval] &&
        mExtendedFingerCount == [aFrame extenedFingerCount] &&
        [mPalmPosition isEqualToVector:[aFrame palmPosition]] &&
        [mPalmNormal isEqualToVector:[aFrame palmNormal]])
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
        return @{ kClassKey               : @"frame",
                  kTimeintervalKey        : [NSNumber numberWithDouble:mTimeInterval],
                  kEnabledKey             : @YES,
                  kExtendedFingerCountKey : [NSNumber numberWithInteger:mExtendedFingerCount],
                  kPalmPositionKey        : [mPalmPosition JSONObject],
                  kPalmNormalKey          : [mPalmNormal JSONObject] };
    }
    else
    {
        return @{ kClassKey               : @"frame",
                  kTimeintervalKey        : [NSNumber numberWithDouble:mTimeInterval],
                  kEnabledKey             : @NO };
    }
}


@end
