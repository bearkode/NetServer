/*
 *  BKEnterBoxEvent.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKEnterBoxEvent.h"


@implementation BKEnterBoxEvent
{
    BKPositionType mEntrancePosition;
    NSDate        *mTimestamp;
}


@synthesize entrancePosition = mEntrancePosition;
@synthesize timestamp        = mTimeStamp;


+ (instancetype)enterBoxEventWithEntrancePosition:(BKPositionType)aPosition
{
    return [[[self alloc] initWithEntrancePosition:aPosition] autorelease];
}


#pragma mark -


- (instancetype)initWithEntrancePosition:(BKPositionType)aPosition
{
    self = [super init];
    
    if (self)
    {
        mEntrancePosition = aPosition;
        mTimeStamp = [[NSDate date] retain];
    }
    
    return self;
}


- (void)dealloc
{
    [mTimeStamp release];
    
    [super dealloc];
}


#pragma mark -


- (BKEventType)type
{
    return BKEventTypeEnterBox;
}


@end
