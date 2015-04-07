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
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{

}


@end
