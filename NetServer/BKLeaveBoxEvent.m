/*
 *  BKLeaveBoxEvent.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKLeaveBoxEvent.h"


@implementation BKLeaveBoxEvent
{
    BKPositionType mLeavePosition;
}


+ (instancetype)leaveEventWithLeavePosition:(BKPositionType)aPosition
{
    return [[[self alloc] initWithLeavePosition:aPosition] autorelease];
}


- (instancetype)initWithLeavePosition:(BKPositionType)aPosition
{
    self = [super init];
    
    if (self)
    {
        mLeavePosition = aPosition;
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
    return BKEventTypeLeaveBox;
}


@end
