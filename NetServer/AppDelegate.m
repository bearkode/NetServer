/*
 *  AppDelegate.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 6..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "AppDelegate.h"
#import "BKNetService.h"
#import "BKMotionManager.h"
#import "BKPrepareBox.h"


@implementation AppDelegate
{
    BKMotionManager *mMotionManager;

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

    mMotionManager = [[BKMotionManager alloc] init];
    [mMotionManager setDelegate:self];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{

}


- (void)motionManager:(BKMotionManager *)aMotionManager didUpdateMotion:(BKMotion *)aMotion
{
    if ([BKPrepareBox containsPosition:[aMotion palmPosition]])
    {
        NSLog(@"in");
    }
    else
    {
        BKPositionType sPositionType = [BKPrepareBox typeForPosition:[aMotion palmPosition]];
        if (sPositionType == BKPositionLeftOfBox)
        {
            NSLog(@"left");
        }
        else if (sPositionType == BKPositionRightOfBox)
        {
            NSLog(@"right");
        }
        else if (sPositionType == BKPositionUnderBox)
        {
            NSLog(@"under");
        }
        else if (sPositionType == BKPositionOverBox)
        {
            NSLog(@"over");
        }
        else if (sPositionType == BKPositionFrontOfBox)
        {
            NSLog(@"front");
        }
        else if (sPositionType == BKPositionBackOfBox)
        {
            NSLog(@"back");
        }
    }

    [[BKNetService sharedService] sendJSONObject:[aMotion JSONObject]];
}


@end
