/*
 *  BKEventState.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 28..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKEventState.h"


@implementation BKEventState
{
    BKFrameBuffer *mFrameBuffer;
}


- (void)dealloc
{
    [mFrameBuffer release];
    
    [super dealloc];
}


- (void)setFrameBuffer:(BKFrameBuffer *)aFrameBuffer
{
    [mFrameBuffer autorelease];
    mFrameBuffer = [aFrameBuffer retain];
}


- (BKEvent *)detectEvent
{
    return nil;
}


- (BOOL)detectOnline
{
    if ([mFrameBuffer isLastFrameEnabled])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (BOOL)detectOffline
{
    if (![mFrameBuffer isLastFrameEnabled])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (BOOL)detectEnterBox
{
    if ([mFrameBuffer isLastFrameEnabled] && [mFrameBuffer lastPostion] == BKPositionInBox)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (BOOL)detectLeaveBox
{
    if ([mFrameBuffer lastPostion] != BKPositionInBox)
    {
        return YES;
    }
    else
    {
        return NO;
    }
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
