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
    LeapHand *sHand= [self firstHand];

    if (sHand)
    {
//        LeapVector *sHandDir     = [sHand direction];
//        LeapVector *sHandNormal  = [sHand palmNormal];
//        LeapVector *sHandPositon = [sHand palmPosition];

//        NSLog(@"position = %1.2f, %1.2f, %1.2f", [sHandPositon x], [sHandPositon y], [sHandPositon z]);
        
//        NSLog(@"%2.1f, %2.1f, %2.1f - %2.1f, %2.1f, %2.1f", [sHandDir x], [sHandDir y], [sHandDir z], [sHandNormal x], [sHandNormal y], [sHandNormal z]);
//        
//        NSMutableString *sLog     = [NSMutableString stringWithString:@"["];
//        NSArray         *sFingers = [sHand fingers];
//        
//        for (LeapFinger *sFinger in sFingers)
//        {
//            LeapVector *sDir   = [sFinger direction];
//            float       sAngle = [sHandDir angleTo:sDir];
//            
//            [sLog appendFormat:@"%2.1f ", sAngle];
//        }
//        [sLog appendString:@"]"];
//        
//        NSLog(@"angle = %@", sLog);
    }

    [self setMotion:[sHand motion]];
}


- (BOOL)isInPrepareZone:(LeapVector *)aVector
{
    if ([aVector x] >= -70 && [aVector x] <= 70 &&
        [aVector y] >= 100 && [aVector y] <= 200 &&
        [aVector z] >= -70 && [aVector z] <= 70)
    {
        return YES;
    }
    else
    {
        return NO;
    }
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
