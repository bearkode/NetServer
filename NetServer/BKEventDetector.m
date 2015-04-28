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

#import "BKOnlineEvent.h"
#import "BKOfflineEvent.h"
#import "BKEnterBoxEvent.h"
#import "BKLeaveBoxEvent.h"
#import "BKStandbyEvent.h"
#import "BKSwipeEvent.h"
#import "BKUpDownEvent.h"
#import "BKClaspEvent.h"
#import "BKCountEvent.h"


@implementation BKEventDetector
{
    BKFrameBuffer  *mFrameBuffer;
    
    BKEventState   *mEventState;
    
    BKEvent        *mLastEvent;
    BKPositionType  mLastPosition;
    NSInteger       mLastFingerCount;
}


#pragma mark -


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        mFrameBuffer = [[BKFrameBuffer alloc] init];
        mEventState  = [[BKEventState alloc] init];
        
        [mEventState setFrameBuffer:mFrameBuffer];
    }
    
    return self;
}


- (void)dealloc
{
    [mFrameBuffer release];
    [mEventState release];
    
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
    BKEvent *sEvent = nil;
    
    if ([mLastEvent type] == BKEventTypeUnknown)
    {
        sEvent = [self detectAfterUnknownEvent];
    }
    if ([mLastEvent type] == BKEventTypeOffline)
    {
        sEvent = [self detectAfterOfflineEvent];
    }
    else if ([mLastEvent type] == BKEventTypeOnline)
    {
        sEvent = [self detectAfterOnlineEvent];
    }
    else if ([mLastEvent type] == BKEventTypeEnterBox)
    {
        sEvent = [self detectAfterEnterBoxEvent];
    }
    else if ([mLastEvent type] == BKEventTypeLeaveBox)
    {
        sEvent = [self detectAfterLeaveBoxEvent];
    }
    else if ([mLastEvent type] == BKEventTypeStandby)
    {
        sEvent = [self detectAfterStandbyEvent];
    }
    else if ([mLastEvent type] == BKEventTypeSwipe)
    {
        sEvent = [self detectAfterSwipeEvent];
    }
    else if ([mLastEvent type] == BKEventTypeUpDown)
    {
        sEvent = [self detectAfterUpDownEvent];
    }
    else if ([mLastEvent type] == BKEventTypeClasp)
    {
        sEvent = [self detectAfterClaspEvent];
    }
    else if ([mLastEvent type] == BKEventTypeCount)
    {
        sEvent = [self detectAfterCountEvent];
    }

    if (sEvent)
    {
        [self setEvent:sEvent];
    }
    
    mLastPosition = [mFrameBuffer lastPostion];
}


#pragma mark -


- (BKEvent *)detectAfterUnknownEvent
{
    return [self detectAfterOfflineEvent];
}


- (BKEvent *)detectAfterOfflineEvent
{
    BKEvent *sResult = nil;
    
    if ([mEventState detectOnline])
    {
        sResult = [BKOnlineEvent onlineEventWithEntrancePosition:[mFrameBuffer lastPostion]];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterOnlineEvent
{
    //  detect enterBox or offline
    
    BKEvent *sResult = nil;

    if ([mEventState detectEnterBox])
    {
        sResult = [BKEnterBoxEvent enterBoxEventWithEntrancePosition:mLastPosition];
    }
    else if ([mEventState detectOffline])
    {
        sResult = [BKOfflineEvent offlineEventWithPosition:mLastPosition];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterEnterBoxEvent
{
    //  detect leaveBox, standby, clasp, count, swipe, updown

    BKEvent *sResult = nil;
    
    if ([mEventState detectLeaveBox])
    {
        sResult = [BKLeaveBoxEvent leaveEventWithLeavePosition:[mFrameBuffer lastPostion]];
    }
    else
    {
        if ([mEventState detectStandby])
        {
            sResult = [BKStandbyEvent standbyEvent];
        }
        else if ([mEventState detectClasp])
        {
            sResult = [BKClaspEvent claspEventWithCount:1];
            
            [mFrameBuffer clear];
        }
        else
        {
            NSInteger sFingerCount = [mEventState detectFingerCount];
            if (sFingerCount != -1 && sFingerCount != mLastFingerCount)
            {
                sResult = [BKCountEvent countEventWithCount:sFingerCount];

                mLastFingerCount = sFingerCount;
            }
        }
    }
    
    return sResult;
}


- (BKEvent *)detectAfterLeaveBoxEvent
{
    //  detect offline, enterBox,
    
    BKEvent *sResult = nil;
    
    if ([mEventState detectEnterBox])
    {
        sResult = [BKEnterBoxEvent enterBoxEventWithEntrancePosition:mLastPosition];
    }
    else if ([mEventState detectOffline])
    {
        sResult = [BKOfflineEvent offlineEventWithPosition:mLastPosition];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterStandbyEvent
{
    //  detect clasp, count, leaveBox
    
    BKEvent *sResult = nil;
    
    if ([mEventState detectLeaveBox])
    {
        sResult = [BKLeaveBoxEvent leaveEventWithLeavePosition:[mFrameBuffer lastPostion]];
    }
    else if ([mEventState detectClasp])
    {
        sResult = [BKClaspEvent claspEventWithCount:1];
        
        [mFrameBuffer clear];
    }
    else
    {
        NSInteger sFingerCount = [mEventState detectFingerCount];

        if (sFingerCount != -1 && sFingerCount != mLastFingerCount)
        {
            sResult = [BKCountEvent countEventWithCount:sFingerCount];

            mLastFingerCount = sFingerCount;
        }
    }
    
    return sResult;
}


- (BKEvent *)detectAfterSwipeEvent
{
    BKEvent *sResult = nil;
    
    if ([mEventState detectStandby])
    {
        sResult = [BKStandbyEvent standbyEvent];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterUpDownEvent
{
    BKEvent *sResult = nil;
    
    if ([mEventState detectStandby])
    {
        sResult = [BKStandbyEvent standbyEvent];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterClaspEvent
{
    BKEvent *sResult = nil;
    
    if ([mEventState detectStandby])
    {
        sResult = [BKStandbyEvent standbyEvent];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterCountEvent
{
    BKEvent *sResult = nil;
    
    if ([mEventState detectStandby])
    {
        sResult = [BKStandbyEvent standbyEvent];
    }
    else if ([mEventState detectClasp])
    {
        sResult = [BKClaspEvent claspEventWithCount:1];
        
        [mFrameBuffer clear];
    }
    
    return sResult;
}


#pragma mark -


- (void)setEvent:(BKEvent *)aEvent
{
    [mLastEvent autorelease];
    mLastEvent = [aEvent retain];
    
    NSLog(@"%@", NSStringFromClass([mLastEvent class]));
}


@end
