/*
 *  BKVector.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 10..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKVector.h"


double const kRoundFactor = 1000;


@implementation BKVector


@synthesize x = mX;
@synthesize y = mY;
@synthesize z = mZ;


- (instancetype)initWithX:(double)aX y:(double)aY z:(double)aZ
{
    self = [super init];
    
    if (self)
    {
        mX = round(aX * kRoundFactor) / kRoundFactor;
        mY = round(aY * kRoundFactor) / kRoundFactor;
        mZ = round(aZ * kRoundFactor) / kRoundFactor;
    }
    
    return self;
}


- (instancetype)initWithJSONObject:(id)aJSONObject
{
    double sX = [[aJSONObject objectForKey:@"x"] doubleValue];
    double sY = [[aJSONObject objectForKey:@"y"] doubleValue];
    double sZ = [[aJSONObject objectForKey:@"z"] doubleValue];
    
    return [self initWithX:sX y:sY z:sZ];
}


- (void)dealloc
{
    [super dealloc];
}


- (BOOL)isEqualToVector:(BKVector *)aVector
{
    if ([aVector x] == mX &&
        [aVector y] == mY &&
        [aVector z] == mZ)
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
    return @{ @"class" : @"vector",
              @"x"     : [NSNumber numberWithFloat:mX],
              @"y"     : [NSNumber numberWithFloat:mY],
              @"z"     : [NSNumber numberWithFloat:mZ] };
}


@end
