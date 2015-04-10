/*
 *  BKMotionManager.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 10..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKMotionManager.h"
#import "LeapObjectiveC.h"
#import "LeapHand+BKAdditions.h"


@implementation BKMotionManager
{
    LeapController *mLeapController;
    BKMotion       *mMotion;
    
    id              mDelegate;
}


@synthesize delegate = mDelegate;


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        mLeapController = [[LeapController alloc] init];
        [mLeapController addListener:self];

        mMotion = [[BKMotion alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mMotion release];
    [mLeapController release];
    
    [super dealloc];
}


- (void)onInit:(NSNotification *)aNotification
{
    NSLog(@"onInit");
}


- (void)onConnect:(NSNotification *)aNotification
{
    NSLog(@"onConnect");
}


- (void)onDeviceChange:(NSNotification *)aNotification
{
    NSLog(@"onDeviceChange");
}


- (void)onDisconnect:(NSNotification *)aNotification
{
    NSLog(@"onDisconnect");
}


- (void)onExit:(NSNotification *)aNotification
{
    NSLog(@"onExit");
}


- (void)onFocusGained:(NSNotification *)aNotification
{
    NSLog(@"onFocusGained");
}


- (void)onFocusLost:(NSNotification *)aNotification
{
    NSLog(@"onFocusLost");
}


- (void)onFrame:(NSNotification *)aNotification
{
    LeapHand *sHand   = [self firstHand];
    
    [self setMotion:[sHand motion]];
}


- (void)onImages:(NSNotification *)aNotification
{
    NSLog(@"onImages");
}


- (void)onServiceConnect:(NSNotification *)aNotification
{
    NSLog(@"onServiceConnect");
}


- (void)onServiceDisconnect:(NSNotification *)aNotification
{
    NSLog(@"onServiceDisconnect");
}


#pragma mark -


- (LeapHand *)firstHand
{
    LeapFrame *sFrame = [mLeapController frame:0];
    
    return [[sFrame hands] firstObject];
}


- (void)setMotion:(BKMotion *)aMotion
{
    if (mMotion && aMotion)
    {
        if (![aMotion isEqualToMotion:mMotion])
        {
            [mMotion autorelease];
            mMotion = [aMotion retain];
            
            [self didChangeMotion];
        }
    }
}


- (void)didChangeMotion
{
//    NSLog(@"didChangeMotion = %@", mMotion);
    
    if ([mDelegate respondsToSelector:@selector(motionManager:didUpdateMotion:)])
    {
        [mDelegate motionManager:self didUpdateMotion:mMotion];
    }
}


@end
