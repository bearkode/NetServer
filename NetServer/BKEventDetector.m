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
#import "BKEnterBoxEvent.h"
#import "BKLeaveBoxEvent.h"
#import "BKSwipeEvent.h"
#import "BKUpDownEvent.h"
#import "BKClaspEvent.h"
#import "BKCountEvent.h"


static NSUInteger const kBufferSize = 100;


@implementation BKEventDetector
{
    NSMutableArray *mHands;
    
    BKEvent        *mLastEvent;
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
    if ([mLastEvent type] == BKEventTypeUnknown)
    {
        //  detect online
    }
    else if ([mLastEvent type] == BKEventTypeOnline)
    {
        //  detect enterBox or offline
    }
    else if ([mLastEvent type] == BKEventTypeOffline)
    {
        //  detect online
    }
    else if ([mLastEvent type] == BKEventTypeEnterBox)
    {
        //  detect leaveBox, clasp, count, swipe, updown
    }
    else if ([mLastEvent type] == BKEventTypeLeaveBox)
    {
        //  detect offline, enterBox,
    }
    else if ([mLastEvent type] == BKEventTypeSwipe)
    {
        //  detect 
    }
}


@end
