/*
 *  BKEventDetector.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKEventDetector.h"
#import "BKTypes.h"
#import "BKPrepareBox.h"

#import "BKOnlineEvent.h"
#import "BKOfflineEvent.h"
#import "BKEnterBoxEvent.h"
#import "BKLeaveBoxEvent.h"
#import "BKStandbyEvent.h"
#import "BKSwipeEvent.h"
#import "BKUpDownEvent.h"
#import "BKClaspEvent.h"
#import "BKCountEvent.h"


static NSUInteger const kBufferSize = 100;


@implementation BKEventDetector
{
    NSMutableArray *mHands;
    
    BKEvent        *mLastEvent;
    BKPositionType  mLastPosition;
    NSInteger       mLastFingerCount;
}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        mHands = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mHands release];
    
    [super dealloc];
}


- (BOOL)addHand:(BKHand *)aHand
{
    if (!aHand)
    {
        return NO;
    }
    
    BKHand *sLastHand = [mHands lastObject];
    
    if (![aHand isEqualToHand:sLastHand])
    {
        [mHands addObject:aHand];
        
        if ([mHands count] > kBufferSize)
        {
            [mHands removeObjectAtIndex:0];
        }
        
        [self detect];
        
        return YES;
    }
    else
    {
        return NO;
    }
}


- (void)detect
{
    BKHand         *sLastHand = [mHands lastObject];
    BKPositionType sPosition  = [BKPrepareBox typeForPosition:[sLastHand palmPosition]];

    if (!mLastEvent || [mLastEvent type] == BKEventTypeUnknown || [mLastEvent type] == BKEventTypeOffline)
    {
        //  detect online
        if ([sLastHand isEnabled])
        {
            BKEvent *sOnlineEvent = [BKOnlineEvent onlineEventWithEntrancePosition:sPosition];
            [self setEvent:sOnlineEvent];
        }
    }
    else if ([mLastEvent type] == BKEventTypeOnline)
    {
        //  detect enterBox or offline
        if ([sLastHand isEnabled])
        {
            if (sPosition == BKPositionInBox)
            {
                BKEvent *sEnterBoxEvent = [BKEnterBoxEvent enterBoxEventWithEntrancePosition:mLastPosition];
                [self setEvent:sEnterBoxEvent];
            }
        }
        else
        {
            BKEvent *sOfflineEvent = [BKOfflineEvent offlineEventWithPosition:mLastPosition];
            [self setEvent:sOfflineEvent];
        }
    }
    else if ([mLastEvent type] == BKEventTypeEnterBox)
    {
        //  detect leaveBox, standby, clasp, count, swipe, updown
        
        if (sPosition != BKPositionInBox)
        {
            BKEvent *sLeaveBoxEvent = [BKLeaveBoxEvent leaveEventWithLeavePosition:sPosition];
            [self setEvent:sLeaveBoxEvent];
        }
        else
        {
            if ([self detectStandby])
            {
                BKEvent *sStandbyEvent = [BKStandbyEvent standbyEvent];
                [self setEvent:sStandbyEvent];
            }
        }
    }
    else if ([mLastEvent type] == BKEventTypeLeaveBox)
    {
        //  detect offline, enterBox,
        if ([sLastHand isEnabled])
        {
            if (sPosition == BKPositionInBox)
            {
                BKEvent *sEnterBoxEvent = [BKEnterBoxEvent enterBoxEventWithEntrancePosition:mLastPosition];
                [self setEvent:sEnterBoxEvent];
            }
        }
        else
        {
            BKEvent *sOfflineEvent = [BKOfflineEvent offlineEventWithPosition:mLastPosition];
            [self setEvent:sOfflineEvent];
        }
    }
    else if ([mLastEvent type] == BKEventTypeStandby)
    {
        //  detect clasp, count, leaveBox
        
        if (sPosition != BKPositionInBox)
        {
            BKEvent *sLeaveBoxEvent = [BKLeaveBoxEvent leaveEventWithLeavePosition:sPosition];
            [self setEvent:sLeaveBoxEvent];
        }

//        NSInteger sFingerCount = [sLastHand extenedFingerCount];
        NSInteger sFingerCount = [self detectFingerCount];
        if (sFingerCount != -1 && sFingerCount != mLastFingerCount)
        {
            BKEvent *sCountEvent = [BKCountEvent countEventWithCount:sFingerCount];
            [self setEvent:sCountEvent];
            mLastFingerCount = sFingerCount;
            NSLog(@"fingerCount = %d", (int)sFingerCount);
        }
    }
    else if ([mLastEvent type] == BKEventTypeSwipe)
    {
        //  detect standby
    }
    else if ([mLastEvent type] == BKEventTypeUpDown)
    {
        //  detect standby
    }
    else if ([mLastEvent type] == BKEventTypeClasp)
    {
        //  detect standby
    }
    else if ([mLastEvent type] == BKEventTypeCount)
    {
        if ([self detectStandby])
        {
            BKEvent *sStandbyEvent = [BKStandbyEvent standbyEvent];
            [self setEvent:sStandbyEvent];
        }
    }
    
    mLastPosition = sPosition;
}


- (void)setEvent:(BKEvent *)aEvent
{
    [mLastEvent autorelease];
    mLastEvent = [aEvent retain];
    
    NSLog(@"%@", NSStringFromClass([mLastEvent class]));
}


- (BOOL)detectStandby
{
    __block BOOL   sResult           = YES;
    BKVector      *sLastPosition     = [[mHands lastObject] palmPosition];
    NSTimeInterval sLastTimeInterval = [[mHands lastObject] timeInterval];
    
    [self reverseEnumerateHandsUsingBlock:^(NSInteger aIndex, BKHand *aHand, BOOL *aStop) {
        BKVector *sPosition = [aHand palmPosition];

        if ((sLastTimeInterval - [aHand timeInterval]) > 0.5)
        {
            *aStop  = YES;
            return;
        }
        
        CGFloat sDeltaX   = fabsf([sLastPosition x] - [sPosition x]);
        CGFloat sDeltaY   = fabsf([sLastPosition y] - [sPosition y]);
        CGFloat sDeltaZ   = fabsf([sLastPosition z] - [sPosition z]);
        CGFloat sCritical = 10.0;
        
        //        NSLog(@"%f, %f, %f", sDeltaX, sDeltaY, sDeltaZ);
        
        if (sDeltaX > sCritical || sDeltaY > sCritical || sDeltaZ > sCritical)
        {
            sResult = NO;
            *aStop  = YES;
        }
    }];
    
    return sResult;
}


- (NSInteger)detectFingerCount
{
    __block BOOL      sDetected         = YES;
    NSTimeInterval    sLastTimeInterval = [[mHands lastObject] timeInterval];
    NSInteger         sLastCount        = [[mHands lastObject] extenedFingerCount];

    [self reverseEnumerateHandsUsingBlock:^(NSInteger aIndex, BKHand *aHand, BOOL *aStop) {
        
        if ([aHand extenedFingerCount] != sLastCount)
        {
            sDetected = NO;
            *aStop    = YES;
            return;
        }

        if ((sLastTimeInterval - [aHand timeInterval]) > 0.5)
        {
            *aStop = YES;
            return;
        }
    }];
    
    return (sDetected) ? sLastCount : -1;
}


- (void)reverseEnumerateHandsUsingBlock:(void (^)(NSInteger aIndex, BKHand *aHand, BOOL *aStop))aBlock
{
    if (!aBlock)
    {
        return;
    }
    
    NSInteger sCount = [mHands count];
    
    for (NSInteger i = (sCount - 1); i >= 0; i--)
    {
        BKHand *sHand = [mHands objectAtIndex:i];
        BOOL    sStop = NO;
        
        aBlock(i, sHand, &sStop);
        
        if (sStop)
        {
            break;
        }
    }
}


@end
