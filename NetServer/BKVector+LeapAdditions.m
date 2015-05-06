/*
 *  BKVector+LeapAdditions.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKVector+LeapAdditions.h"


@implementation BKVector (LeapAdditions)


+ (instancetype)vectorWithLeapVector:(LeapVector *)aLeapVector;
{
    return [[[self alloc] initWithLeapVector:aLeapVector] autorelease];
}


- (instancetype)initWithLeapVector:(LeapVector *)aLeapVector
{
    return [self initWithX:[aLeapVector x] y:[aLeapVector y] z:[aLeapVector z]];
}


@end
