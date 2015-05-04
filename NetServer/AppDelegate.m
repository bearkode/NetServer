/*
 *  AppDelegate.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 6..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "AppDelegate.h"
#import "BKEventManager.h"
#import "BKNEtService.h"
#import "BKPrepareBox.h"
#import "BKEvents.h"


@implementation AppDelegate
{
    BKEventManager *mEventManager;

    NSTextField     *mPrevLabel;
    NSTextField     *mNextLabel;
    NSTextField     *mStatusLabel;
    NSTextField     *mUpLabel;
    NSTextField     *mDownLabel;
}


@synthesize prevLabel   = mPrevLabel;
@synthesize nextLabel   = mNextLabel;
@synthesize statusLabel = mStatusLabel;
@synthesize upLabel     = mUpLabel;
@synthesize downLabel   = mDownLabel;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [BKNetService sharedService];

    mEventManager = [[BKEventManager alloc] init];
    [mEventManager setNetServiceEnabled:YES];
    [mEventManager setDelegate:self];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{

}


- (void)eventManager:(BKEventManager *)aEventManager didDetectEvent:(BKEvent *)aEvent
{
    if ([aEvent type] == BKEventTypeSwipe)
    {
        BKSwipeEvent *sSwipeEvent = (BKSwipeEvent *)aEvent;
        if ([sSwipeEvent isNext])
        {
            NSLog(@"next");
        }
        else if ([sSwipeEvent isPrev])
        {
            NSLog(@"prev");
        }
    }
    else if ([aEvent type] == BKEventTypeUpDown)
    {
        BKUpDownEvent *sUpDownEvent = (BKUpDownEvent *)aEvent;
        if ([sUpDownEvent isUp])
        {
            NSLog(@"up");
        }
        else if ([sUpDownEvent isDown])
        {
            NSLog(@"down");
        }
    }
    else if ([aEvent type] == BKEventTypeClasp)
    {
        BKClaspEvent *sClaspEvent = (BKClaspEvent *)aEvent;
        NSLog(@"clasp [%d]", (int)[sClaspEvent count]);
    }
}


@end
