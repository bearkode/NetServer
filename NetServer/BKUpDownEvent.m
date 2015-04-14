/*
 *  BKUpDownEvent.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKUpDownEvent.h"


@implementation BKUpDownEvent
{
    BKPositionType mPosition;
}


+ (instancetype)upDownEventWithPosition:(BKPositionType)aPosition
{
    return [[[self alloc] initWithPosition:aPosition] autorelease];
}


- (instancetype)initWithPosition:(BKPositionType)aPosition
{
    self = [super init];
    
    if (self)
    {
        mPosition = aPosition;
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
    return BKEventTypeUpDown;
}


@end
