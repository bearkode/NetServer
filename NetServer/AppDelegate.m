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


- (void)eventManager:(BKEventManager *)aEventManager didUpdateFrame:(BKFrame *)aFrame
{
//    if ([aHand isEnabled])
//    {
//        if ([BKPrepareBox containsPosition:[aHand palmPosition]])
//        {
//            NSLog(@"in");
//        }
//        else
//        {
//            BKPositionType sPositionType = [BKPrepareBox typeForPosition:[aHand palmPosition]];
//            if (sPositionType == BKPositionLeftOfBox)
//            {
//                NSLog(@"left");
//            }
//            else if (sPositionType == BKPositionRightOfBox)
//            {
//                NSLog(@"right");
//            }
//            else if (sPositionType == BKPositionUnderBox)
//            {
//                NSLog(@"under");
//            }
//            else if (sPositionType == BKPositionOverBox)
//            {
//                NSLog(@"over");
//            }
//            else if (sPositionType == BKPositionFrontOfBox)
//            {
//                NSLog(@"front");
//            }
//            else if (sPositionType == BKPositionBackOfBox)
//            {
//                NSLog(@"back");
//            }
//        }
//    }
}


@end
