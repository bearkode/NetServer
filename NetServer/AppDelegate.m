/*
 *  AppDelegate.m
 *  NetServer
 *
 *  Created by cgkim on 2015. 4. 6..
 *  Copyright (c) 2015 cgkim. All rights reserved.
 *
 */

#import "AppDelegate.h"
#import "BKNetService.h"


@implementation AppDelegate
{

}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [BKNetService sharedService];
    
    [NSTimer scheduledTimerWithTimeInterval:(1.0 / 30.0) target:self selector:@selector(detectMousePosition:) userInfo:nil repeats:YES];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{

}


- (void)detectMousePosition:(NSTimer *)aTimer
{
    [[BKNetService sharedService] setMousePosition:[NSEvent mouseLocation]];
}


@end
