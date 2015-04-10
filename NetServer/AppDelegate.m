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


@implementation AppDelegate
{
    BKMotionManager *mMotionManager;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [BKNetService sharedService];

    mMotionManager = [[BKMotionManager alloc] init];
    [mMotionManager setDelegate:self];
    
//    [NSTimer scheduledTimerWithTimeInterval:(1.0 / 30.0) target:self selector:@selector(detectMousePosition:) userInfo:nil repeats:YES];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{

}


- (void)detectMousePosition:(NSTimer *)aTimer
{
    [[BKNetService sharedService] setMousePosition:[NSEvent mouseLocation]];
}


- (void)motionManager:(BKMotionManager *)aMotionManager didUpdateMotion:(BKMotion *)aMotion
{
//    NSLog(@"motion updated = %@", [aMotion JSONObject]);
    [[BKNetService sharedService] sendJSONObject:[aMotion JSONObject]];
}


@end
