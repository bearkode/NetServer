/*
 *  BKEnterEvent.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKEnterEvent.h"


@implementation BKEnterEvent
{
    BKPositionType mEntrancePosition;
}


+ (instancetype)enterEventWithEntrancePosition:(BKPositionType)aPosition
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
    return BKEventTypeEnter;
}


@end
