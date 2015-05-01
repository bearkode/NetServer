/*
 *  BKEventState.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 28..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKEventState.h"
#import "BKFrameBuffer.h"
#import "BKFrameBuffer+Detector.h"
#import "BKOnlineEvent.h"
#import "BKOfflineEvent.h"
#import "BKEnterBoxEvent.h"
#import "BKLeaveBoxEvent.h"
#import "BKStandbyEvent.h"
#import "BKSwipeEvent.h"
#import "BKUpDownEvent.h"
#import "BKClaspEvent.h"
#import "BKCountEvent.h"


@implementation BKEventState
{
    BKEvent       *mLastEvent;
    BKPositionType mLastPosition;
    BKEvent       *mLastCountEvent;
}


- (void)dealloc
{
    [super dealloc];
}


- (BKEvent *)detectEventFromBuffer:(BKFrameBuffer *)aFrameBuffer
{
    BKEvent *sEvent = nil;
    
    if ([mLastEvent type] == BKEventTypeUnknown)
    {
        sEvent = [self detectAfterUnknownEventWithBuffer:aFrameBuffer];
    }
    if ([mLastEvent type] == BKEventTypeOffline)
    {
        sEvent = [self detectAfterOfflineEventWithBuffer:aFrameBuffer];
    }
    else if ([mLastEvent type] == BKEventTypeOnline)
    {
        sEvent = [self detectAfterOnlineEventWithBuffer:aFrameBuffer];
    }
    else if ([mLastEvent type] == BKEventTypeEnterBox)
    {
        sEvent = [self detectAfterEnterBoxEventWithBuffer:aFrameBuffer];
    }
    else if ([mLastEvent type] == BKEventTypeLeaveBox)
    {
        sEvent = [self detectAfterLeaveBoxEventWithBuffer:aFrameBuffer];
    }
    else if ([mLastEvent type] == BKEventTypeStandby)
    {
        sEvent = [self detectAfterStandbyEventWithBuffer:aFrameBuffer];
    }
    else if ([mLastEvent type] == BKEventTypeSwipe)
    {
        sEvent = [self detectAfterSwipeEventWithBuffer:aFrameBuffer];
    }
    else if ([mLastEvent type] == BKEventTypeUpDown)
    {
        sEvent = [self detectAfterUpDownEventWithBuffer:aFrameBuffer];
    }
    else if ([mLastEvent type] == BKEventTypeClasp)
    {
        sEvent = [self detectAfterClaspEventWithBuffer:aFrameBuffer];
    }
    else if ([mLastEvent type] == BKEventTypeCount)
    {
        sEvent = [self detectAfterCountEventWithBuffer:aFrameBuffer];
    }
    
    if (sEvent)
    {
        [mLastEvent autorelease];
        mLastEvent = [sEvent retain];
    }
    
    mLastPosition = [aFrameBuffer lastPosition];
    
    return sEvent;
}


#pragma mark -


- (BKEvent *)detectAfterUnknownEventWithBuffer:(BKFrameBuffer *)aBuffer
{
    return [aBuffer detectOnlineEvent];
}


- (BKEvent *)detectAfterOfflineEventWithBuffer:(BKFrameBuffer *)aBuffer
{
    return [aBuffer detectOnlineEvent];
}


- (BKEvent *)detectAfterOnlineEventWithBuffer:(BKFrameBuffer *)aBuffer
{
    //  detect enterBox or offline
    
    BKEvent *sResult = [aBuffer detectEnterBoxEvent];
    
    if (!sResult)
    {
        sResult = [aBuffer detectOfflineEvent];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterEnterBoxEventWithBuffer:(BKFrameBuffer *)aBuffer
{
    //  detect leaveBox, standby, clasp, count, swipe, updown
    
    BKEvent *sResult = [aBuffer detectLeaveBoxEvent];
    
    if (!sResult)
    {
        sResult = [aBuffer detectStandbyEvent];
    }
    
    if (!sResult)
    {
        sResult = [aBuffer detectClaspEvent];
    }
    
    if (!sResult)
    {
        sResult = [aBuffer detectFingerCountEvent];
        if (mLastCountEvent == sResult)
        {
            sResult = nil;
        }
        else
        {
            [mLastCountEvent autorelease];
            mLastCountEvent = [sResult retain];
        }
    }
    
    return sResult;
}


- (BKEvent *)detectAfterLeaveBoxEventWithBuffer:(BKFrameBuffer *)aBuffer
{
    //  detect offline, enterBox,
    
    BKEvent *sResult = [aBuffer detectEnterBoxEvent];
    
    if (!sResult)
    {
        sResult = [aBuffer detectOfflineEvent];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterStandbyEventWithBuffer:(BKFrameBuffer *)aBuffer
{
    //  detect clasp, count, leaveBox
    
    BKEvent *sResult = [aBuffer detectLeaveBoxEvent];
    
    if (!sResult)
    {
        sResult = [aBuffer detectClaspEvent];
    }

    if (!sResult)
    {
        sResult = [aBuffer detectFingerCountEvent];
        if (mLastCountEvent == sResult)
        {
            sResult = nil;
        }
        else
        {
            [mLastCountEvent autorelease];
            mLastCountEvent = [sResult retain];
        }
    }
    
    return sResult;
}


- (BKEvent *)detectAfterSwipeEventWithBuffer:(BKFrameBuffer *)aBuffer
{
    return [aBuffer detectStandbyEvent];
}


- (BKEvent *)detectAfterUpDownEventWithBuffer:(BKFrameBuffer *)aBuffer
{
    return [aBuffer detectStandbyEvent];
}


- (BKEvent *)detectAfterClaspEventWithBuffer:(BKFrameBuffer *)aBuffer
{
    return [aBuffer detectStandbyEvent];
}


- (BKEvent *)detectAfterCountEventWithBuffer:(BKFrameBuffer *)aBuffer
{
    BKEvent *sResult = [aBuffer detectClaspEvent];
    
    if (!sResult)
    {
        sResult = [aBuffer detectStandbyEvent];
    }
    
    if (!sResult)
    {
        sResult = [aBuffer detectLeaveBoxEvent];
    }

    return sResult;
}


@end
