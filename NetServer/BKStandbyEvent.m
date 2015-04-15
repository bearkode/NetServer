/*
 *  BKStandbyEvent.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKStandbyEvent.h"


@implementation BKStandbyEvent


+ (instancetype)standbyEvent
{
    return [[[self alloc] init] autorelease];
}


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
    [super dealloc];
}


#pragma mark -


- (BKEventType)type
{
    return BKEventTypeStandby;
}


@end
