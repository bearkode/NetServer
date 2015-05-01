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

#import "BKClaspEvent.h"


@implementation BKEventDetector
{
    BKFrameBuffer *mFrameBuffer;
    BKEventState  *mEventState;
}


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
    if ([aEvent isKindOfClass:[BKClaspEvent class]])
    {
        NSLog(@"clear buffer");
        [mFrameBuffer clear];
    }
    
    NSLog(@"%@", NSStringFromClass([aEvent class]));
}


@end
