/*
 *  BKMotion.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 10..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKMotion.h"


@implementation BKMotion
{
    NSInteger mExtendedFingerCount;
    BKVector *mPalmPosition;
    BKVector *mPalmNormal;
}


@synthesize extenedFingerCount = mExtendedFingerCount;
@synthesize palmPosition       = mPalmPosition;
@synthesize palmNormal         = mPalmNormal;


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
    
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


- (BOOL)isEqualToMotion:(BKMotion *)aMotion
{
    if (mExtendedFingerCount == [aMotion extenedFingerCount] &&
        [mPalmPosition isEqualToVector:[aMotion palmPosition]] &&
        [mPalmNormal isEqualToVector:[aMotion palmNormal]])
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
    return @{ @"class" : @"motion",
              @"extendedFingerCount" : [NSNumber numberWithInteger:mExtendedFingerCount],
              @"palmPosition" : [mPalmPosition JSONObject],
              @"palmNormal" : [mPalmNormal JSONObject] };
}


@end
