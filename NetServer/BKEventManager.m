/*
 *  BKEventManager.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 10..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKEventManager.h"
#import "BKLeapController.h"
#import "BKNetService.h"
#import "BKEventDetector.h"


@implementation BKEventManager
{
    BKLeapController *mLeapController;
    
    BOOL              mNetServiceEnabled;
    BKEventDetector  *mEventDetector;
    
    id                mDelegate;
}


@synthesize delegate          = mDelegate;
@synthesize netServiceEnabled = mNetServiceEnabled;


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        mLeapController = [[BKLeapController alloc] initWithDelegate:self];
        mEventDetector  = [[BKEventDetector alloc] init];
        
        [mEventDetector setDelegate:self];
    }
    
    return self;
}


- (void)dealloc
{
    [mLeapController release];
    [mEventDetector release];
    
    [super dealloc];
}


#pragma mark -


- (void)leapController:(BKLeapController *)aLeapController didUpdateFrame:(BKFrame *)aFrame
{
    if ([mEventDetector addFrame:aFrame])
    {
        if ([mDelegate respondsToSelector:@selector(eventManager:didUpdateFrame:)])
        {
            [mDelegate eventManager:self didUpdateFrame:aFrame];
        }
    }
    
    if (mNetServiceEnabled)
    {
        [[BKNetService sharedService] sendJSONObject:[aFrame JSONObject]];
    }
}


//- (void)eventDetector:(BKEventDetector *)aDetector did

- (void)eventDetector:(BKEventDetector *)aDetector didDetectEvent:(BKEvent *)aEvent
{
    if ([mDelegate respondsToSelector:@selector(eventManager:didDetectEvent:)])
    {
        [mDelegate eventManager:self didDetectEvent:aEvent];
    }
}


@end
