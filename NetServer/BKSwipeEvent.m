/*
 *  BKSwipeEvent.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKSwipeEvent.h"


@implementation BKSwipeEvent
{
    BKPositionType mPosition;
}


+ (instancetype)swipeEventWithPosition:(BKPositionType)aPosition
{
    return [[[self alloc] initWithPosition:aPosition] autorelease];
}


#pragma mark -


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
    return BKEventTypeSwipe;
}


- (BOOL)isNext
{
    return (mPosition == BKPositionLeftOfBox) ? YES : NO;
}


- (BOOL)isPrev
{
    return (mPosition == BKPositionRightOfBox) ? YES : NO;
}


@end
