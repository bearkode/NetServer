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


static NSArray *gOfflineEventNames = nil;
static NSArray *gOutboxEventNames  = nil;
static NSArray *gInboxEventNames   = nil;


@implementation BKEventState
{
    NSArray       *mDetectEventNames;
    BKEvent       *mLastEvent;
    BKPositionType mLastPosition;
    BKEvent       *mLastCountEvent;
}


+ (void)initialize
{
    gOfflineEventNames = [@[[BKOnlineEvent className]] retain];
    gOutboxEventNames  = [@[[BKEnterBoxEvent className],
                            [BKOfflineEvent className]] retain];
    gInboxEventNames   = [@[[BKLeaveBoxEvent className],
                            [BKClaspEvent className],
                            [BKCountEvent className]] retain];
}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        mDetectEventNames = gOfflineEventNames;
    }
    
    return self;
}


- (void)dealloc
{
    [mLastEvent release];
    [mLastCountEvent release];
    
    [super dealloc];
}


- (BKEvent *)detectEventFromBuffer:(BKFrameBuffer *)aFrameBuffer
{
    BKEvent *sEvent = [aFrameBuffer detectEvents:mDetectEventNames];
    
    sEvent        = [self postProcess:sEvent];
    mLastPosition = [aFrameBuffer lastPosition];
    
    return sEvent;
}


#pragma mark -

- (BKEvent *)postProcess:(BKEvent *)aEvent
{
    BKEvent *sResult = aEvent;
    
    if ([sResult isKindOfClass:[BKCountEvent class]])
    {
        sResult = [self postProcessForCountEvent:sResult];
    }

    if (sResult)
    {
        [self setLastEvent:sResult];
    }
    
    return sResult;
}


- (BKEvent *)postProcessForCountEvent:(BKEvent *)aEvent
{
    if (mLastCountEvent == aEvent)
    {
        return nil;
    }
    else
    {
        [mLastCountEvent autorelease];
        mLastCountEvent = [aEvent retain];
        
        return aEvent;
    }
}


- (void)setLastEvent:(BKEvent *)aEvent
{
    static NSDictionary   *sTable;
    static dispatch_once_t sOnceToken;

    dispatch_once(&sOnceToken, ^{
        sTable = @{ [BKOnlineEvent className]   : gOutboxEventNames,
                    [BKOfflineEvent className]  : gOfflineEventNames,
                    [BKEnterBoxEvent className] : gInboxEventNames,
                    [BKLeaveBoxEvent className] : gOutboxEventNames,
                    [BKStandbyEvent className]  : gInboxEventNames,
                    [BKSwipeEvent className]    : gInboxEventNames,
                    [BKUpDownEvent className]   : gInboxEventNames,
                    [BKClaspEvent className]    : gInboxEventNames,
                    [BKCountEvent className]    : gInboxEventNames };
        
        [sTable retain];
    });
    
    [mLastEvent autorelease];
    mLastEvent = [aEvent retain];

    mDetectEventNames = [sTable objectForKey:[[aEvent class] className]];
    NSAssert(mDetectEventNames, @"");
}


@end
