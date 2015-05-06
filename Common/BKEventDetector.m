/*
 *  BKEventDetector.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKEventDetector.h"
#import "BKFrameBuffer.h"
#import "BKTypes.h"
#import "BKEventState.h"

#import "BKEnterBoxEvent.h"
#import "BKLeaveBoxEvent.h"
#import "BKUpDownEvent.h"
#import "BKSwipeEvent.h"
#import "BKClaspEvent.h"


@implementation BKEventDetector
{
    id               mDelegate;
    
    BKFrameBuffer   *mFrameBuffer;
    BKEventState    *mEventState;
    
    BKLeaveBoxEvent *mLastLeaveBoxEvent;
    BKUpDownEvent   *mLastUpDownEvent;
}


@synthesize delegate = mDelegate;


#pragma mark -


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        mFrameBuffer = [[BKFrameBuffer alloc] init];
        mEventState  = [[BKEventState alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mFrameBuffer release];
    [mEventState release];
    
    [mLastLeaveBoxEvent release];
    
    [super dealloc];
}


#pragma mark -


- (BOOL)addFrame:(BKFrame *)aFrame
{
    if ([mFrameBuffer addFrame:aFrame])
    {
        [self detect];

        return YES;
    }
    
    return NO;
}


#pragma mark -


- (void)detect
{
    BKEvent *sEvent = [mEventState detectEventFromBuffer:mFrameBuffer];
    
    if (sEvent)
    {
        [self eventDidDetect:sEvent];
    }
}


#pragma mark -


- (void)eventDidDetect:(BKEvent *)aEvent
{
    if ([mDelegate respondsToSelector:@selector(eventDetector:didDetectEvent:)])
    {
        [mDelegate eventDetector:self didDetectEvent:aEvent];
    }
    
    if ([aEvent isKindOfClass:[BKClaspEvent class]])
    {
        [mFrameBuffer clear];
    }
    
    if ([aEvent isKindOfClass:[BKLeaveBoxEvent class]])
    {
        [mLastLeaveBoxEvent autorelease];
        mLastLeaveBoxEvent = (BKLeaveBoxEvent *)[aEvent retain];
    }
    
    [self detectSwipeUpDownEvent:aEvent];
}


- (void)detectSwipeUpDownEvent:(BKEvent *)aEvent
{
    if ([aEvent isKindOfClass:[BKEnterBoxEvent class]] && mLastLeaveBoxEvent)
    {
        BKEnterBoxEvent *sEnterEvent = (BKEnterBoxEvent *)aEvent;
        NSTimeInterval   sTimeGap    = [[sEnterEvent timestamp] timeIntervalSince1970] - [[mLastLeaveBoxEvent timestamp] timeIntervalSince1970];
        
        if (sTimeGap < 1.0)
        {
            BKEvent *sEvent = nil;
            
            if ([sEnterEvent entrancePosition] == BKPositionLeftOfBox)
            {
                sEvent = [BKSwipeEvent swipeEventWithPosition:BKPositionLeftOfBox];
            }
            else if ([sEnterEvent entrancePosition] == BKPositionRightOfBox)
            {
                sEvent = [BKSwipeEvent swipeEventWithPosition:BKPositionRightOfBox];
            }
            else if ([sEnterEvent entrancePosition] == BKPositionOverBox)
            {
                sEvent = [BKUpDownEvent upDownEventWithPosition:BKPositionOverBox];
            }
            else if ([sEnterEvent entrancePosition] == BKPositionUnderBox)
            {
                sEvent = [BKUpDownEvent upDownEventWithPosition:BKPositionUnderBox];
            }
            
            if (sEvent)
            {
                [self eventDidDetect:sEvent];
            }
        }
    }
}


@end
