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
    static NSDictionary   *sEventTable = nil;
    static dispatch_once_t sOnceToken;
    
    dispatch_once(&sOnceToken, ^{
        sEventTable = [@{ @1 : [[[self alloc] initWithCount:1] autorelease],
                          @2 : [[[self alloc] initWithCount:2] autorelease],
                          @3 : [[[self alloc] initWithCount:3] autorelease],
                          @4 : [[[self alloc] initWithCount:4] autorelease],
                          @5 : [[[self alloc] initWithCount:5] autorelease] } retain];
    });
    
    
    return [sEventTable objectForKey:[NSNumber numberWithInteger:aCount]];
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
