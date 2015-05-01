/*
 *  BKFrameBuffer+Detector.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 29..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKFrameBuffer+Detector.h"
#import "BKOnlineEvent.h"
#import "BKOfflineEvent.h"
#import "BKEnterBoxEvent.h"
#import "BKLeaveBoxEvent.h"
#import "BKStandbyEvent.h"
#import "BKCountEvent.h"
#import "BKClaspEvent.h"


@implementation BKFrameBuffer (Detector)


- (BKEvent *)detectEvents:(NSArray *)aEvents
{
    static NSDictionary   *sSelectorTable;
    static dispatch_once_t sOnceToken;
    
    dispatch_once(&sOnceToken, ^{
        sSelectorTable = [@{ [BKOnlineEvent className]   : NSStringFromSelector(@selector(detectOnlineEvent)),
                             [BKOfflineEvent className]  : NSStringFromSelector(@selector(detectOfflineEvent)),
                             [BKEnterBoxEvent className] : NSStringFromSelector(@selector(detectEnterBoxEvent)),
                             [BKLeaveBoxEvent className] : NSStringFromSelector(@selector(detectLeaveBoxEvent)),
                             [BKStandbyEvent className]  : NSStringFromSelector(@selector(detectStandbyEvent)),
                             [BKCountEvent className]    : NSStringFromSelector(@selector(detectFingerCountEvent)),
                             [BKClaspEvent className]    : NSStringFromSelector(@selector(detectClaspEvent))} retain];
    });
    
    BKEvent *sResult = nil;
    
    for (NSString *sEventClassName in aEvents)
    {
        SEL sSelector = NSSelectorFromString([sSelectorTable objectForKey:sEventClassName]);
        
        if (sSelector)
        {
            sResult = [self performSelector:sSelector withObject:nil];
        }
        
        if (sResult)
        {
            break;
        }
    }
    
    return sResult;
}


- (BKEvent *)detectOnlineEvent
{
    if ([self isLastFrameEnabled])
    {
        return [BKOnlineEvent onlineEventWithEntrancePosition:[self lastPosition]];
    }
    else
    {
        return nil;
    }
}


- (BKEvent *)detectOfflineEvent
{
    if (![self isLastFrameEnabled])
    {
        return [BKOfflineEvent offlineEventWithPosition:[self prevPosition]];
    }
    else
    {
        return nil;
    }
}


- (BKEvent *)detectEnterBoxEvent
{
    if ([self isLastFrameEnabled] && [self lastPosition] == BKPositionInBox)
    {
        return [BKEnterBoxEvent enterBoxEventWithEntrancePosition:[self prevPosition]];
    }
    else
    {
        return nil;
    }
}


- (BKEvent *)detectLeaveBoxEvent
{
    if ([self lastPosition] != BKPositionInBox)
    {
        return [BKLeaveBoxEvent leaveEventWithLeavePosition:[self prevPosition]];
    }
    else
    {
        return nil;
    }
}


- (BKEvent *)detectStandbyEvent
{
    __block BOOL sDetected     = YES;
    BKVector    *sLastPosition = [[self lastFrame] palmPosition];
    
    [self enumerateFramesUsingBlock:^(BKFrame *aHand, BOOL *aStop) {
        BKVector *sPosition = [aHand palmPosition];
        
        CGFloat sDeltaX   = fabs([sLastPosition x] - [sPosition x]);
        CGFloat sDeltaY   = fabs([sLastPosition y] - [sPosition y]);
        CGFloat sDeltaZ   = fabs([sLastPosition z] - [sPosition z]);
        CGFloat sCritical = 10.0;
        
        //        NSLog(@"%f, %f, %f", sDeltaX, sDeltaY, sDeltaZ);
        
        if (sDeltaX > sCritical || sDeltaY > sCritical || sDeltaZ > sCritical)
        {
            sDetected = NO;
            *aStop  = YES;
        }
        
    } timeout:0.5];
    
    return (sDetected) ? [BKStandbyEvent standbyEvent] : nil;
}


- (BKEvent *)detectFingerCountEvent
{
    __block BOOL sDetected  = YES;
    NSInteger    sLastCount = [[self lastFrame] extenedFingerCount];
    
    [self enumerateFramesUsingBlock:^(BKFrame *aHand, BOOL *aStop) {
        if ([aHand extenedFingerCount] != sLastCount)
        {
            sDetected = NO;
            *aStop    = YES;
            return;
        }
    } timeout:0.5];
    
    return (sDetected) ? [BKCountEvent countEventWithCount:sLastCount] : nil;
}


- (BKEvent *)detectClaspEvent
{
    __block BOOL sDetected     = NO;
    __block BOOL sZeroDetected = NO;
    __block BOOL sFiveDetected = NO;
    
    if ([[self lastFrame] extenedFingerCount] == 5)
    {
        [self enumerateFramesUsingBlock:^(BKFrame *aHand, BOOL *aStop) {
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
    
    return (sDetected) ? [BKClaspEvent claspEventWithCount:1] : nil;
}


@end
