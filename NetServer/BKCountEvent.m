/*
 *  BKCountEvent.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKCountEvent.h"


@implementation BKCountEvent
{
    NSInteger mCount;
}


+ (instancetype)countEventWithCount:(NSInteger)aCount
{
    return [[[self alloc] initWithCount:aCount] autorelease];
}


- (instancetype)initWithCount:(NSInteger)aCount
{
    self = [super init];
    
    if (self)
    {
        mCount = aCount;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (BKEventType)type
{
    return BKEventTypeCount;
}


@end
