/*
 *  BKFrameBuffer.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 28..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKFrameBuffer.h"
#import "BKPrepareBox.h"


static NSUInteger const kBufferSize = 100;


@implementation BKFrameBuffer
{
    NSMutableArray *mBuffer;
    
    BKPositionType  mLastPosition;
    BOOL            mLastFrameEnabled;
}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        mBuffer = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mBuffer release];
    
    [super dealloc];
}


- (BOOL)addFrame:(BKFrame *)aFrame
{
    if (!aFrame)
    {
        return NO;
    }
    
    BKFrame *sLastFrame = [mBuffer firstObject];
    
    if (![aFrame isEqualToFrame:sLastFrame])
    {
        [mBuffer insertObject:aFrame atIndex:0];
        [self frameDidAdd];

        return YES;
    }


    return NO;
}


- (void)clear
{
    [mBuffer removeAllObjects];
}


- (BKFrame *)lastFrame
{
    return [mBuffer lastObject];
}


- (BKPositionType)lastPostion
{
    return mLastPosition;
}


- (BOOL)isLastFrameEnabled
{
    return mLastFrameEnabled;
}


- (void)enumerateFramesUsingBlock:(void (^)(BKFrame *aHand, BOOL *aStop))aBlock timeout:(NSTimeInterval)aTimeInterval
{
    if (!aBlock)
    {
        return;
    }
    
    NSTimeInterval sLastTimeInterval = [[self lastFrame] timeInterval];

    for (BKFrame *sFrame in mBuffer)
    {
        if ((sLastTimeInterval - [sFrame timeInterval]) > 1.0)
        {
            break;
        }

        BOOL sStop = NO;

        aBlock(sFrame, &sStop);
        
        if (sStop)
        {
            break;
        }
    }
}


#pragma mark -


- (void)frameDidAdd
{
    BKFrame *sLastFrame = [mBuffer lastObject];
    
    mLastPosition     = [BKPrepareBox typeForPosition:[sLastFrame palmPosition]];
    mLastFrameEnabled = [sLastFrame isEnabled];
    
    if ([mBuffer count] > kBufferSize)
    {
        [mBuffer removeLastObject];
    }
}




@end
