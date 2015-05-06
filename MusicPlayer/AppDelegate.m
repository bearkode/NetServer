/*
 *  AppDelegate.m
 *  MusicPlayer
 *
 *  Created by bearkode on 2015. 5. 4..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "AppDelegate.h"
#import "BKPlayListViewController.h"


@implementation AppDelegate
{
    UIWindow *mWindow;
}


@synthesize window = mWindow;


- (BOOL)application:(UIApplication *)aApplication didFinishLaunchingWithOptions:(NSDictionary *)aLaunchOptions
{
    UIWindow *sWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [sWindow makeKeyAndVisible];
    [self setWindow:sWindow];
    
    BKPlayListViewController *sViewController = [[[BKPlayListViewController alloc] init] autorelease];
    UINavigationController   *sNaviController = [[[UINavigationController alloc] initWithRootViewController:sViewController] autorelease];
    [[self window] setRootViewController:sNaviController];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)aApplication
{

}


- (void)applicationDidEnterBackground:(UIApplication *)aApplication
{

}


- (void)applicationWillEnterForeground:(UIApplication *)aApplication
{

}


- (void)applicationDidBecomeActive:(UIApplication *)aApplication
{

}


- (void)applicationWillTerminate:(UIApplication *)application
{

}


@end
