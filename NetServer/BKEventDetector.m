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
    }
    
    return self;
}


- (void)dealloc
{
    [mFrameBuffer release];
    
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
    
    if (!mLastEvent || [mLastEvent type] == BKEventTypeUnknown || [mLastEvent type] == BKEventTypeOffline)
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


- (BKEvent *)detectAfterUnknownEvent
{
    return [self detectAfterOfflineEvent];
}


- (BKEvent *)detectAfterOfflineEvent
{
    BKEvent *sResult = nil;
    
    if ([mFrameBuffer isLastFrameEnabled])
    {
        sResult = [BKOnlineEvent onlineEventWithEntrancePosition:[mFrameBuffer lastPostion]];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterOnlineEvent
{
    //  detect enterBox or offline
    
    BKEvent *sResult = nil;

    if ([mFrameBuffer isLastFrameEnabled])
    {
        if ([mFrameBuffer lastPostion] == BKPositionInBox)
        {
            sResult = [BKEnterBoxEvent enterBoxEventWithEntrancePosition:mLastPosition];
        }
    }
    else
    {
        sResult = [BKOfflineEvent offlineEventWithPosition:mLastPosition];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterEnterBoxEvent
{
    //  detect leaveBox, standby, clasp, count, swipe, updown

    BKEvent *sResult = nil;
    
    if ([mFrameBuffer lastPostion] != BKPositionInBox)
    {
        sResult = [BKLeaveBoxEvent leaveEventWithLeavePosition:[mFrameBuffer lastPostion]];
    }
    else
    {
        if ([self detectStandby])
        {
            sResult = [BKStandbyEvent standbyEvent];
        }
        else if ([self detectClasp])
        {
            sResult = [BKClaspEvent claspEventWithCount:1];
            
            [mFrameBuffer clear];
        }
        else
        {
            NSInteger sFingerCount = [self detectFingerCount];
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
    
    if ([mFrameBuffer isLastFrameEnabled])
    {
        if ([mFrameBuffer lastPostion] == BKPositionInBox)
        {
            sResult = [BKEnterBoxEvent enterBoxEventWithEntrancePosition:mLastPosition];
        }
    }
    else
    {
        sResult = [BKOfflineEvent offlineEventWithPosition:mLastPosition];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterStandbyEvent
{
    //  detect clasp, count, leaveBox
    
    BKEvent *sResult = nil;
    
    if ([mFrameBuffer lastPostion] != BKPositionInBox)
    {
        sResult = [BKLeaveBoxEvent leaveEventWithLeavePosition:[mFrameBuffer lastPostion]];
    }
    else if ([self detectClasp])
    {
        sResult = [BKClaspEvent claspEventWithCount:1];
        
        [mFrameBuffer clear];
    }
    else
    {
        NSInteger sFingerCount = [self detectFingerCount];

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
    
    if ([self detectStandby])
    {
        sResult = [BKStandbyEvent standbyEvent];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterUpDownEvent
{
    BKEvent *sResult = nil;
    
    if ([self detectStandby])
    {
        sResult = [BKStandbyEvent standbyEvent];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterClaspEvent
{
    BKEvent *sResult = nil;
    
    if ([self detectStandby])
    {
        sResult = [BKStandbyEvent standbyEvent];
    }
    
    return sResult;
}


- (BKEvent *)detectAfterCountEvent
{
    BKEvent *sResult = nil;
    
    if ([self detectStandby])
    {
        sResult = [BKStandbyEvent standbyEvent];
    }
    else if ([self detectClasp])
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


- (BOOL)detectStandby
{
    __block BOOL sResult       = YES;
    BKVector    *sLastPosition = [[mFrameBuffer lastFrame] palmPosition];
    
    [mFrameBuffer enumerateFramesUsingBlock:^(BKFrame *aHand, BOOL *aStop) {
        BKVector *sPosition = [aHand palmPosition];
        
        CGFloat sDeltaX   = fabs([sLastPosition x] - [sPosition x]);
        CGFloat sDeltaY   = fabs([sLastPosition y] - [sPosition y]);
        CGFloat sDeltaZ   = fabs([sLastPosition z] - [sPosition z]);
        CGFloat sCritical = 10.0;
        
        //        NSLog(@"%f, %f, %f", sDeltaX, sDeltaY, sDeltaZ);
        
        if (sDeltaX > sCritical || sDeltaY > sCritical || sDeltaZ > sCritical)
        {
            sResult = NO;
            *aStop  = YES;
        }

    } timeout:0.5];

    return sResult;
}


- (NSInteger)detectFingerCount
{
    __block BOOL sDetected  = YES;
    NSInteger    sLastCount = [[mFrameBuffer lastFrame] extenedFingerCount];
    
    [mFrameBuffer enumerateFramesUsingBlock:^(BKFrame *aHand, BOOL *aStop) {
        if ([aHand extenedFingerCount] != sLastCount)
        {
            sDetected = NO;
            *aStop    = YES;
            return;
        }
    } timeout:0.5];

    return (sDetected) ? sLastCount : -1;
}


- (BOOL)detectClasp
{
    __block BOOL sDetected     = NO;
    __block BOOL sZeroDetected = NO;
    __block BOOL sFiveDetected = NO;
    
    if ([[mFrameBuffer lastFrame] extenedFingerCount] == 5)
    {
        [mFrameBuffer enumerateFramesUsingBlock:^(BKFrame *aHand, BOOL *aStop) {
            NSInteger sFingerCount = [aHand extenedFingerCount];
            
            if (!sZeroDetected && sFingerCount == 0)
            {
                sZeroDetected = YES;
            }
            
            if (sZeroDetected && !sFiveDetected && sFingerCount == 5)
            {
                sFiveDetected = YES;
                sDetected     = YES;
                *aStop        = YES;
                
                return;
            }
        } timeout:1.0];
    }
    
    return sDetected;
}


@end
